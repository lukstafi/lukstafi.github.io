#!/usr/bin/env python3
"""Serve the site from the repo root to devices on the Tailnet.

Binds to this machine's Tailscale address and to loopback, so the LAN cannot
reach it. `tailscale serve` adds HTTPS on port 443 for as long as this script
runs, forwarding to the loopback listener. The repo root also holds credentials
and private notes, so the server refuses dotfiles, git-ignored paths, and
directory listings.

Usage: scripts/serve_tailnet.py [--port 8000]
"""

import argparse
import functools
import http
import http.server
import json
import signal
import subprocess
import sys
import threading
import urllib.parse
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOOPBACK = "127.0.0.1"


def tailscale_address():
    """Return the Tailscale IPv4 address, MagicDNS name, and HTTPS availability."""
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
    status = json.loads(status)
    dns_name = status.get("Self", {}).get("DNSName", "").rstrip(".")
    return ip, dns_name, dns_name in (status.get("CertDomains") or [])


def start_https(port):
    """Start `tailscale serve` in the foreground; return it, or None on failure."""
    process = subprocess.Popen(
        ["tailscale", "serve", "--yes", "--https=443", f"http://{LOOPBACK}:{port}"],
        stdout=subprocess.DEVNULL,
    )
    try:
        process.wait(timeout=2)
    except subprocess.TimeoutExpired:
        return process
    print("tailscale serve exited, so HTTPS is off.", file=sys.stderr)
    return None


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

    ip, dns_name, https_available = tailscale_address()
    handler = functools.partial(SiteHandler, directory=str(ROOT))
    for host in (ip, LOOPBACK):
        server = http.server.ThreadingHTTPServer((host, args.port), handler)
        threading.Thread(target=server.serve_forever, daemon=True).start()

    # Without this, `kill` would leave `tailscale serve` running.
    signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
    https = start_https(args.port) if https_available else None

    print(f"Serving {ROOT}")
    if https:
        print(f"  https://{dns_name}/")
    elif not https_available:
        print("HTTPS needs HTTPS Certificates on in the Tailscale admin console.")
    print(f"  http://{ip}:{args.port}/")
    if dns_name:
        print(f"  http://{dns_name}:{args.port}/")
    print("Press Ctrl-C to stop.", flush=True)
    try:
        threading.Event().wait()
    except KeyboardInterrupt:
        pass
    finally:
        if https:
            https.terminate()
            https.wait()


if __name__ == "__main__":
    main()
