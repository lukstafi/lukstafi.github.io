#!/usr/bin/env python3
"""Refresh scripts/.substack-cookies.json from a browser session.

Substack's `substack.sid` session cookie expires (and does not survive being
copied from another machine once the session is invalidated), so this has to be
redone periodically. Run it from an interactive terminal:

    .venv-substack/bin/python scripts/refresh_substack_cookie.py

Get the value from a browser signed in to Substack:
  Chrome/Brave/Edge : DevTools (Cmd-Opt-I) > Application > Storage > Cookies
                      > https://substack.com > substack.sid > copy Value
  Firefox           : DevTools (Cmd-Opt-I) > Storage > Cookies
  Safari            : enable Develop menu, then Web Inspector > Storage > Cookies

The paste is read with getpass, so it is not echoed to the terminal and does not
land in shell history. The file is written 0600 and is git-ignored.
"""

from __future__ import annotations

import getpass
import json
import os
import stat
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
COOKIE_PATH = REPO_ROOT / "scripts" / ".substack-cookies.json"


def main() -> None:
    value = getpass.getpass("Paste substack.sid value (hidden, then Enter): ").strip()
    value = value.strip('"').strip("'")

    if not value:
        sys.exit("error: nothing pasted")
    if not value.startswith(("s%3A", "s:")):
        sys.exit(
            f"error: that does not look like a substack.sid value (got {value[:8]!r}...).\n"
            "       Copy the Value column of the `substack.sid` cookie, not the whole\n"
            "       cookie header and not the Name column."
        )
    if value.startswith("s:"):
        # DevTools sometimes shows the decoded form; the API wants it encoded.
        from urllib.parse import quote

        value = "s%3A" + quote(value[2:], safe="")
        print("note: re-encoded the decoded `s:` form for the API")

    COOKIE_PATH.write_text(json.dumps({"substack.sid": value}))
    COOKIE_PATH.chmod(stat.S_IRUSR | stat.S_IWUSR)  # 0600
    print(f"wrote {COOKIE_PATH.relative_to(REPO_ROOT)} ({len(value)} chars, mode 0600)")

    try:
        import requests
    except ImportError:
        print("requests not available; skipping verification")
        return

    r = requests.get(
        "https://substack.com/api/v1/user/profile/self",
        cookies={"substack.sid": value},
        headers={"User-Agent": "Mozilla/5.0"},
        timeout=20,
    )
    if r.status_code == 200:
        who = r.json()
        print(f"verified: signed in as {who.get('name') or who.get('handle') or who.get('id')}")
    else:
        print(f"NOT verified: HTTP {r.status_code} {r.text[:120]}")
        print("The cookie was written anyway; re-run once you have a live session.")
        sys.exit(1)


if __name__ == "__main__":
    main()
