# Mochi File Server app
# Serves static files from the files/ data directory
# Copyright Alistair Cunningham 2025

def action_serve(a):
    """Serve static files based on domain route context"""
    # Context specifies the site subdirectory (e.g., "apt", "docs")
    site = a.domain.route.context
    if not site:
        a.error(400, "This app requires domain routing configuration")
        return

    # Validate site is safe (alphanumeric, underscores, hyphens only)
    if not site.replace("_", "").replace("-", "").isalnum():
        a.error(400, "Invalid site configuration")
        return

    # Remainder is the file path after the route prefix
    path = a.domain.route.remainder
    if not path:
        path = "index.html"

    # Serve from files/{site}/{path}
    a.write_from_file(site + "/" + path)
