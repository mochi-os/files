# Mochi File Server app
# Serves static files from the files/ data directory
# Copyright © 2026 Mochisoft OÜ
# SPDX-License-Identifier: AGPL-3.0-only
# This file is part of Mochi, licensed under the GNU AGPL v3 with the
# Mochi Application Interface Exception - see license.txt and license-exception.md.

def action_serve(a):
    """Serve static files based on domain route context"""
    # Only a request that arrived on a hosted domain may read the file store.
    # Reached directly on the app's own path, this action is public and runs as
    # the first administrator, which published their whole tree on the main
    # origin - every site's files at once, whatever hostname they were meant
    # for, and any HTML among them executing on the primary origin.
    # Answered as a plain 404 rather than an explanation: what is configured
    # here is not the caller's business.
    route = a.domain.route
    if not route:
        a.error.label(404, "errors.not_found")
        return

    # Context specifies an optional site subdirectory (e.g., "apt", "docs").
    # Not re-validated here: the routing table is the server's, and the only two
    # writes that set a context check it first. Checking it again meant keeping a
    # copy of someone else's rule, which is how this app came to accept a context
    # that every later request then failed on - isalnum() counts any Unicode
    # letter, and the path the context is prepended to is ASCII only.
    site = route.context

    # Remainder is the file path after the route prefix
    path = route.remainder
    if not path:
        path = "index.html"

    # Serve from files/{site}/{path} or files/{path}
    if site:
        path = site + "/" + path
    a.write.file(path)
