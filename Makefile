# Makefile for Mochi apps
# Copyright © 2026 Mochisoft OÜ
# SPDX-License-Identifier: AGPL-3.0-only
# This file is part of Mochi, licensed under the GNU AGPL v3 with the
# Mochi Application Interface Exception - see license.txt and license-exception.md.

APP = $(notdir $(CURDIR))
VERSION = $(shell grep -m1 '"version"' app.json | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
RELEASE = ../../release

all:

clean:

release:
	rm -f $(RELEASE)/$(APP)_*.zip
	zip -r $(RELEASE)/$(APP)_$(VERSION).zip app.json *.star labels
	# Tagged by claude/scripts/commit.sh when the version bump is committed:
	# tagging here runs before that commit, so the tag named the one before it.

deploy:
	../../test/claude/deploy.sh $(APP)

commit:
	git add -A && git commit -m "$(VERSION)" || true

push:
	git push --follow-tags

everything: clean release deploy commit push
