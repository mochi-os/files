# Makefile for Mochi apps
# Copyright Alistair Cunningham 2025

APP = $(notdir $(CURDIR))
VERSION = $(shell grep -m1 '"version"' app.json | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
BUILD = ../../build

all:

clean:

zip:
	mkdir -p $(BUILD)
	rm -f $(BUILD)/$(APP)_*.zip
	zip -r $(BUILD)/$(APP)_$(VERSION).zip app.json *.star labels
	git tag -a $(VERSION) -m "$(VERSION)"
