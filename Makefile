BOWER 		?= node_modules/.bin/bower
JSHINT 		?= node_modules/.bin/jshint
PEGJS		?= node_modules/.bin/pegjs
PHANTOMJS	?= node_modules/.bin/phantomjs
BINDIR      ?= .bundle/bin
# XXX: See stamp-bundler below.
# BUNDLE      ?= $(BINDIR)/bundle
BUNDLE      ?= bundle

PATTERNS	= src/bower_components/patternslib
SOURCES		= $(wildcard $(PATTERNS)/src/*.js) $(wildcard $(PATTERNS)/src/pat/*.js) $(wildcard $(PATTERNS)/src/lib/*.js)
BUNDLES		= bundles/patterns.js bundles/patterns.min.js

GENERATED	= $(PATTERNS)/src/lib/depends_parse.js

JSHINTEXCEPTIONS = $(GENERATED) \
		   $(PATTERNS)/src/lib/dependshandler.js \
		   $(PATTERNS)/src/lib/htmlparser.js \
		   $(PATTERNS)/src/pat/skeleton.js
CHECKSOURCES	= $(filter-out $(JSHINTEXCEPTIONS),$(SOURCES))

RELEASE         = $(shell git describe --tags)
RELEASE_DIR		= release/prototype
RELEASE_TARBALL = release/prototype-$(RELEASE).tar.gz

# This directory is relative to ./prototype dir.
DIAZO_DIR   = ../src/ploneintranet/theme/static

LATEST          = $(shell cat LATEST)
BUNDLENAME      = ploneintranet
BUNDLEURL		= https://products.syslab.com/packages/$(BUNDLENAME)/$(LATEST)/$(BUNDLENAME)-$(LATEST).tar.gz

all:: jekyll
default: all

########################################################################
## Install dependencies

stamp-npm: package.json
	npm install
	touch stamp-npm

stamp-bower: stamp-npm
	$(BOWER) install
	touch stamp-bower

stamp-bundler:
	# XXX This can be used to install bundler but doesn't work on Jenkins :(
	# mkdir -p $(BINDIR) && gem install --user-install bundler --bindir=$(BINDIR) --no-wrappers
	# $(BUNDLE) install --path .bundle --binstubs $(BINDIR)
	# Instead we now rely on Bundler being installed globally.
	$(BUNDLE) install --path .bundle --binstubs
	touch stamp-bundler

clean::
	rm -rf stamp-npm stamp-bower stamp-bundler node_modules src/bower_components bundles/*

extra-clean:: clean
	rm -rf ~/.cache/bower

check-clean:
	test -z "$(shell git status --porcelain)" || (git status && echo && echo "Workdir not clean." && false) && echo "Workdir clean."

########################################################################
## Tests

jshint: stamp-npm
	$(JSHINT) --config jshintrc $(CHECKSOURCES) build.js


########################################################################
## Bundle generation

bundle: stamp-bower $(SOURCES) build.js
	node_modules/.bin/r.js -o build.js optimize=none
	node_modules/.bin/grunt uglify
	mkdir -p bundles
	mv bundle.js bundles/$(BUNDLENAME)-$(RELEASE).js
	ln -sf $(BUNDLENAME)-$(RELEASE).js bundles/$(BUNDLENAME).js
	mkdir -p _site/bundles
	cp bundles/$(BUNDLENAME)-$(RELEASE).js _site/bundles/$(BUNDLENAME).js
	mv bundle.min.js bundles/$(BUNDLENAME)-$(RELEASE).min.js
	ln -sf $(BUNDLENAME)-$(RELEASE).min.js bundles/$(BUNDLENAME).min.js
	cp bundles/$(BUNDLENAME)-$(RELEASE).min.js _site/bundles/$(BUNDLENAME).min.js

dev-bundle bundle.js: stamp-bower $(SOURCES) build.js
	@node_modules/.bin/r.js -o build.js optimize=none
	@mkdir -p bundles
	@cp bundle.js bundles/$(BUNDLENAME)-dev.js
	@mv bundle.js bundles/$(BUNDLENAME).js
	@echo "Done. See bundles/$(BUNDLENAME)-dev.js and bundles/$(BUNDLENAME).js"

jsrelease: bundle
	# This one is used by developers only and can be used separately to do a
	# version for Designers only
	mkdir -p release
	cp bundles/$(BUNDLENAME)-$(RELEASE).js release
	cp bundles/$(BUNDLENAME)-$(RELEASE).min.js release
	tar cfz release/$(BUNDLENAME)-$(RELEASE).js.tar.gz -C release $(BUNDLENAME)-$(RELEASE).js $(BUNDLENAME)-$(RELEASE).min.js
	curl -X POST -F 'content=@release/$(BUNDLENAME)-$(RELEASE).js.tar.gz' 'https://products.syslab.com/?name=$(BUNDLENAME)&version=$(RELEASE)&:action=file_upload'
	rm release/$(BUNDLENAME)-$(RELEASE).js.tar.gz
	echo "Upload done."
	echo "$(RELEASE)" > LATEST
	git add LATEST
	git commit -m "distupload: updated latest file to recent js bundle"
	git push

fetchrelease:
	@mkdir -p bundles
	@curl $(BUNDLEURL) -o bundles/$(BUNDLENAME)-$(LATEST).tar.gz
	@cd bundles && tar xfz $(BUNDLENAME)-$(LATEST).tar.gz && rm $(BUNDLENAME)-$(LATEST).tar.gz
	@cd bundles && if test -e $(BUNDLENAME).js; then rm $(BUNDLENAME).js; fi
	@cd bundles && if test -e $(BUNDLENAME).min.js; then rm $(BUNDLENAME).min.js; fi
	@cd bundles && ln -sf $(BUNDLENAME)-$(LATEST).js $(BUNDLENAME).js
	@cd bundles && ln -sf $(BUNDLENAME)-$(LATEST).min.js $(BUNDLENAME).min.js
	@echo Done. See the new Javascript bundles in prototype/bundles

designerhappy: fetchrelease
	@echo "The latest js bundle has been downloaded to ./bundles. You might want to run jekyll. Designer, you can be happy now."

jekyll: fetchrelease stamp-bundler
	$(BUNDLE) exec jekyll build

dev: jekyll
	# Set up development environment
	# install a require.js config
	cp src/bower_components/requirejs/require.js _site/bundles/$(BUNDLENAME)-modular.js
	ln -s ../../../src _site/bundles
	ln -s src/patterns.js _site/main.js

########################################################################
# For development (i.e. serving files)
serve: demo-run
demo-run: stamp-bundler
	bundle exec jekyll serve --watch --baseurl "" --host 0.0.0.0

# for demo.ploneintranet.net deployment
demo-build: stamp-bundler
	bundle exec jekyll build

.PHONY: all bundle extra-clean clean jshint check-clean release serve
