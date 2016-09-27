all: stop prepare build run

.PHONY: prepare build run stop print
REVEAL_URL = https://github.com/hakimel/reveal.js/raw/539e774d31f91676bcc3f75e28168921cd27d819
FILES = \
  js/reveal.js \
  lib/js/head.min.js \
  css/reveal.css \
  css/theme/template/mixins.scss \
  css/theme/template/settings.scss \
  css/theme/template/theme.scss \
  plugin/markdown/marked.js \
  plugin/markdown/markdown.js \
  plugin/notes/notes.html \
  plugin/notes/notes.js

prepare:
	@for FILE in $(FILES); do \
	  docker run --rm -it -v $(CURDIR):/workspace busybox test -e /workspace/dist/reveal/$$FILE || wget -x -nH --cut-dirs=4 $(REVEAL_URL)/$$FILE -P dist/reveal ; \
	done

build:
	@docker run --rm -v $(CURDIR):/workspace -w /workspace jbergknoff/sass /workspace/theme.scss /workspace/build/theme.css
	@docker build -t harmish/hfr2016 .

run:
	@docker run -d --name=hfr2016 \
     --restart=unless-stopped \
     -p 80:80 \
     harmish/hfr2016

stop::
	@docker stop hfr2016 >/dev/null 2>&1 || true
	@docker rm hfr2016 >/dev/null 2>&1 || true

print:
	@mkdir -p out
	@docker run --rm -v $(CURDIR)/out:/slides -v $(CURDIR):/workspace astefanutti/decktape /workspace/index.html hfr2016.pdf
