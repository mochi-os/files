# Mochi File Server app
# Serves static files from the files/ data directory
# Copyright © 2026 Mochisoft OÜ
# SPDX-License-Identifier: AGPL-3.0-only
# This file is part of Mochi, licensed under the GNU AGPL v3 with the
# Mochi Application Interface Exception - see license.txt and license-exception.md.

# Characters a site subdirectory may use. Core accepts ASCII only in a file
# path, so this list rather than isalnum(), which counts any Unicode letter and
# so accepted a context that every later request failed on. Core also caps the
# whole path, prefix included, and reports that itself.
site_characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"

def site_valid(site):
    """Report whether a route context is usable as a path prefix"""
    for i in range(len(site)):
        if site[i] not in site_characters:
            return False
    return True

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

    # Context specifies an optional site subdirectory (e.g., "apt", "docs")
    site = route.context

    if site and not site_valid(site):
        a.error.label(400, "errors.invalid_site_configuration")
        return

    # Remainder is the file path after the route prefix
    path = route.remainder
    if not path:
        path = "index.html"

    # Serve from files/{site}/{path} or files/{path}
    if site:
        path = site + "/" + path
    a.write.file(path)
