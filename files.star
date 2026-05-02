# Mochi File Server app
# Serves static files from the files/ data directory
# Copyright Alistair Cunningham 2025-2026

def action_serve(a):
    """Serve static files based on domain route context"""
    # Context specifies an optional site subdirectory (e.g., "apt", "docs")
    site = a.domain.route.context

    # Validate site is safe (alphanumeric, underscores, hyphens only)
    if site and not site.replace("_", "").replace("-", "").isalnum():
        a.error.label(400, "errors.invalid_site_configuration")
        return

    # Remainder is the file path after the route prefix
    path = a.domain.route.remainder
    if not path:
        path = "index.html"

    # Serve from files/{site}/{path} or files/{path}
    if site:
        path = site + "/" + path
    a.write.file(path)
