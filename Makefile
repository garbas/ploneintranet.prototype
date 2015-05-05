BOWER 		?= node_modules/.bin/bower
JSHINT 		?= node_modules/.bin/jshint
PEGJS		?= node_modules/.bin/pegjs
PHANTOMJS	?= node_modules/.bin/phantomjs
BINDIR      ?= .bundle/bin
BUNDLE      ?= $(BINDIR)/bundle

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

all:: diazo
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
	mkdir -p $(BINDIR)
	echo $(whoami)
	gem install --install-dir=.gem bundler --bindir=$(BINDIR) --no-wrappers
	$(BUNDLE) install --path .bundle --binstubs $(BINDIR)
	touch stamp-bundler

clean::
	rm -f stamp-npm stamp-bower stamp-bundler
	rm -rf node_modules src/bower_components 
	rm -f bundle.js bundles/*

extra-clean:: clean
	~/.cache/bower

check-clean:
	test -z "$(shell git status --porcelain)" || (git status && echo && echo "Workdir not clean." && false) && echo "Workdir clean."

########################################################################
## Tests

check:: jshint test-bundle
jshint: stamp-npm
	$(JSHINT) --config jshintrc $(CHECKSOURCES) build.js


check:: stamp-npm
	$(PHANTOMJS) node_modules/phantom-jasmine/lib/run_jasmine_test.coffee tests/TestRunner.html

########################################################################
## Bundle generation

bundle bundle.js: stamp-bower $(GENERATED) $(SOURCES) build.js
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

test-bundle test-bundle.js: stamp-bundler stamp-bower $(GENERATED) $(SOURCES) test-build.js
	node_modules/.bin/r.js -o test-build.js

$(PATTERNS)/src/lib/depends_parse.js: $(PATTERNS)/src/lib/depends_parse.pegjs stamp-npm
	$(PEGJS) $<
	sed -i~ -e '1s/.*/define(function() {/' -e '$$s/()//' $@ || rm -f $@

jsrelease: bundle.js
	# This one is used by developers only and can be used separately to do a
	# version for Designers only
	mkdir -p release
	cp bundles/$(BUNDLENAME)-$(RELEASE).js release
	tar cfz release/$(BUNDLENAME)-$(RELEASE).js.tar.gz -C release $(BUNDLENAME)-$(RELEASE).js $(BUNDLENAME)-$(RELEASE).min.js
	curl -X POST -F 'content=@release/$(BUNDLENAME)-$(RELEASE).js.tar.gz' 'https://products.syslab.com/?name=$(BUNDLENAME)&version=$(RELEASE)&:action=file_upload'
	rm release/$(BUNDLENAME)-$(RELEASE).js.tar.gz
	echo "Upload done."
	echo "$(RELEASE)" > LATEST
	git add LATEST
	git commit -m "distupload: updated latest file to recent js bundle"
	git push

fetchrelease:
	mkdir -p bundles
	curl $(BUNDLEURL) -o bundles/$(BUNDLENAME)-$(LATEST).tar.gz
	cd bundles && tar xfz $(BUNDLENAME)-$(LATEST).tar.gz && rm $(BUNDLENAME)-$(LATEST).tar.gz
	cd bundles && if test -e $(BUNDLENAME).js; then rm $(BUNDLENAME).js; fi
	cd bundles && if test -e $(BUNDLENAME).min.js; then rm $(BUNDLENAME).min.js; fi
	cd bundles && ln -sf $(BUNDLENAME)-$(LATEST).js $(BUNDLENAME).js
	cd bundles && ln -sf $(BUNDLENAME)-$(LATEST).min.js $(BUNDLENAME).min.js

designerhappy: fetchrelease
	echo "The latest js bundle has been downloaded to ./bundles. You might want to run jekyll. Designer, you can be happy now."

jekyll: stamp-bundler
	$(BUNDLE) exec jekyll build

dev: jekyll
	# Set up development environment
	# install a require.js config
	cp src/bower_components/requirejs/require.js _site/bundles/$(BUNDLENAME)-modular.js
	ln -s ../../../src _site/bundles
	ln -s src/patterns.js _site/main.js

diazo release: fetchrelease jekyll
	# Bundle all html, css and js into a deployable package.
	# I assume that all html in _site and js in _site/bundles is built and
	# ready for upload.
	# CAVE: This is currently work in progress and was used to deploy to deliverance
	# We will most probably rewrite this to deploy all necessary resources
	# for diazo into egg format (Yet to be decided how)
	#
	@[ -d release/prototype ] || mkdir -p release/prototype
	# make sure it is empty
	rm -rf release/prototype/*
	# test "$$(git status --porcelain)x" = "x" || (git status && false)
	cp -R _site $(RELEASE_DIR)/
	sed -i -e "s,<script src=\"bundles/$(BUNDLENAME).js\",<script src=\"bundles/$(shell readlink prototype/bundles/$(BUNDLENAME).js)\"," $(RELEASE_DIR)/_site/*.html
	# Cleaning up non mission critical elements
	rm -f $(RELEASE_DIR)/_site/*-e
	rm -rf $(RELEASE_DIR)/_site/bundles/*
	cp bundles/$(BUNDLENAME)-$(LATEST).js $(RELEASE_DIR)/_site/bundles/
	cp bundles/$(BUNDLENAME)-$(LATEST).min.js $(RELEASE_DIR)/_site/bundles/
	ln -sf $(BUNDLENAME)-$(LATEST).js $(RELEASE_DIR)/_site/bundles/$(BUNDLENAME).js
	ln -sf $(BUNDLENAME)-$(LATEST).min.js $(RELEASE_DIR)/_site/bundles/$(BUNDLENAME).min.js
	# replace absolute resource urls with relative
	sed -i -e "s#http://patterns.cornae.com/#./#" $(RELEASE_DIR)/_site/*.html
	# copy to the diazo theme dir
	@[ -d $(DIAZO_DIR)/generated/ ] || mkdir $(DIAZO_DIR)/generated/
	cp -R $(RELEASE_DIR)/_site/* $(DIAZO_DIR)/generated/

########################################################################
# For development (i.e. serving files)
serve: demo-run
demo-run: stamp-bundler
	bundle exec jekyll serve --watch --baseurl "" --host 0.0.0.0

# for demo.ploneintranet.net deployment
demo-build: stamp-bundler
	bundle exec jekyll build

.PHONY: all bundle extra-clean clean check jshint tests check-clean release serve
