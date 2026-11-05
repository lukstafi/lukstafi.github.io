#!/usr/bin/env python3
"""Serve the site from the repo root to devices on the Tailnet.

Binds to this machine's Tailscale address only, so the LAN cannot reach it.
The repo root also holds credentials and private notes, so the server refuses
dotfiles, git-ignored paths, and directory listings.

Usage: scripts/serve_tailnet.py [--port 8000]
"""

import argparse
import functools
import http
import http.server
import json
import subprocess
import sys
import urllib.parse
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def tailscale_address():
    """Return this machine's Tailscale IPv4 address and MagicDNS name."""
    try:
        ip = subprocess.run(
            ["tailscale", "ip", "-4"], capture_output=True, text=True, check=True
        ).stdout.split()[0]
        status = subprocess.run(
            ["tailscale", "status", "--json"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError, IndexError) as error:
        sys.exit(f"Cannot get the Tailscale address, is Tailscale up? ({error})")
    dns_name = json.loads(status).get("Self", {}).get("DNSName", "").rstrip(".")
    return ip, dns_name


def is_public(path):
    """Tell whether a filesystem path may be served."""
    try:
        relative = Path(path).resolve().relative_to(ROOT)
    except ValueError:
        return False
    if any(part.startswith(".") for part in relative.parts):
        return False
    ignored = subprocess.run(
        ["git", "-C", str(ROOT), "check-ignore", "-q", "--", str(relative)],
        check=False,
    )
    # Exit status 1 means "not ignored"; anything else counts as refused.
    return ignored.returncode == 1


class SiteHandler(http.server.SimpleHTTPRequestHandler):
    def send_head(self):
        request_path = urllib.parse.urlsplit(self.path).path
        if not is_public(self.translate_path(request_path)):
            self.send_error(http.HTTPStatus.NOT_FOUND)
            return None
        return super().send_head()

    def list_directory(self, path):
        self.send_error(http.HTTPStatus.NOT_FOUND)
        return None

    def end_headers(self):
        # Rebuilt pages should show up on reload.
        self.send_header("Cache-Control", "no-store")
        super().end_headers()


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--port", type=int, default=8000)
    args = parser.parse_args()

    ip, dns_name = tailscale_address()
    handler = functools.partial(SiteHandler, directory=str(ROOT))
    with http.server.ThreadingHTTPServer((ip, args.port), handler) as server:
        print(f"Serving {ROOT}")
        print(f"  http://{ip}:{args.port}/")
        if dns_name:
            print(f"  http://{dns_name}:{args.port}/")
        print("Press Ctrl-C to stop.", flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
