# Makefile for Mochi apps
# Copyright Alistair Cunningham 2025

APP = $(notdir $(CURDIR))
VERSION = $(shell grep -m1 '"version"' app.json | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
RELEASE = ../../release

all:

clean:

release:
	rm -f $(RELEASE)/$(APP)_*.zip
	zip -r $(RELEASE)/$(APP)_$(VERSION).zip app.json *.star labels
	git tag -a $(VERSION) -m "$(VERSION)"

deploy:
	../../test/claude/deploy.sh $(APP)

commit:
	git add -A && git commit -m "$(VERSION)" || true

push:
	git push --follow-tags

everything: clean release deploy commit push
