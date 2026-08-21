# Mochi File Server app
# Serves static files from the files/ data directory
# Copyright © 2026 Mochisoft OÜ
# SPDX-License-Identifier: AGPL-3.0-only
# This file is part of Mochi, licensed under the GNU AGPL v3 with the
# Mochi Application Interface Exception - see license.txt and license-exception.md.

def action_serve(a):
    """Serve static files based on domain route context"""
    # Only a request on a hosted domain may read the file store: on the app's
    # own path this public action runs as the first administrator and would
    # serve every site's files on the main origin. A plain 404 - the
    # configuration is not the caller's business.
    route = a.domain.route
    if not route:
        a.error.label(404, "errors.not_found")
        return

    # Context is an optional site subdirectory ("apt", "docs"). Not
    # re-validated: the routing table is the server's and the writes that set a
    # context already check it.
    site = route.context

    # Remainder is the file path after the route prefix
    path = route.remainder
    if not path:
        path = "index.html"

    # Serve from files/{site}/{path} or files/{path}
    if site:
        path = site + "/" + path
    a.write.file(path)
