{
    "baseUrl": "src",
    "out": "bundle.js",
    "name": "almond",
    "include": ["patterns"],
    "insertRequire": ["patterns"],

    "wrap": {
        "endfile": "src/wrap-end.js"
    },

    "paths": {
        // Externals
        "almond":                                 "bower_components/almond/almond",
        "dropzone":                               "bower_components/dropzone/downloads/dropzone",
        "fine-uploader":                          "bower_components/fine-uploader/build/jquery.fineuploader",
        "jcrop":                                  "bower_components/jcrop/js/jquery.Jcrop",
        "jquery":                                 "bower_components/jquery/dist/jquery",
        "jquery.browser":                         "bower_components/jquery.browser/dist/jquery.browser",
        "jquery-hotkeys":                         "bower_components/jquery.hotkeys/jquery.hotkeys",
        "jquery.anythingslider":                  "bower_components/AnythingSlider/js/jquery.anythingslider",
        "jquery.chosen":                          "bower_components/chosen/chosen/chosen.jquery",
        "jquery.form":                            "bower_components/jquery-form/jquery.form",
        "jquery.fullcalendar":                    "bower_components/fullcalendar/fullcalendar",
        "jquery.fullcalendar.dnd":                "bower_components/fullcalendar/lib/jquery-ui.custom.min",
        "jquery.placeholder":                     "bower_components/jquery-placeholder/jquery.placeholder.min",
        "jquery.textchange":                      "bower_components/jquery-textchange/jquery.textchange",
        "jquery.validation":                      "bower_components/jquery.validation/jquery.validate",
        "jquery.validation-additional-methods":   "bower_components/jquery.validation/additional-methods",
        "jqueryui":                               "bower_components/jqueryui/jquery-ui",
        "klass":                                  "bower_components/klass/src/klass",
        "less":                                   "bower_components/less.js/dist/less-1.6.2",
        "logging":                                "bower_components/logging/src/logging",
        "modernizr":                              "bower_components/modernizr/modernizr",
        "modernizr-csspositionsticky":            "bower_components/modernizr/feature-detects/css-positionsticky",
        "picker":                                 "bower_components/pickadate/lib/picker",
        "picker.date":                            "bower_components/pickadate/lib/picker.date",
        "picker.time":                            "bower_components/pickadate/lib/picker.time",
        "parsley":                                "bower_components/parsleyjs/parsley",
        "parsley.extend":                         "bower_components/parsleyjs/parsley.extend",
        "photoswipe":                             "bower_components/patternslib/src/legacy/photoswipe",
        "prefixfree":                             "bower_components/prefixfree/prefixfree.min",
        "rangy":                                  "bower_components/rangy/rangy-core",
        "rangy-cssclassapplier":                  "bower_components/rangy/rangy-cssclassapplier",
        "rangy-selectionsaverestore":             "bower_components/rangy/rangy-selectionsaverestore",
        "rangy-serializer":                       "bower_components/rangy/rangy-serializer",
        "raptor":                                 "bower_components/pat-raptor/3rdparty/raptor",
        "select2":                                "bower_components/select2/select2.min",
        "showdown":                               "bower_components/showdown/src/showdown",
        "showdown-github":                        "bower_components/showdown/src/extensions/github",
        "showdown-prettify":                      "bower_components/showdown/src/extensions/prettify",
        "showdown-table":                         "bower_components/showdown/src/extensions/table",
        "spectrum":                               "bower_components/spectrum/spectrum",
        "text":                                   "bower_components/requirejs-text/text",
        "underscore":                             "bower_components/underscore/underscore",

        // Core
        "i18n":                      "bower_components/patternslib/src/core/i18n",
        "pat-base":                  "bower_components/patternslib/src/core/base",
        "pat-compat":                "bower_components/patternslib/src/core/compat",
        "pat-date-picker":           "bower_components/pat-date-picker/src/pat-date-picker",
        "pat-depends_parse":         "bower_components/patternslib/src/lib/depends_parse",
        "pat-dependshandler":        "bower_components/patternslib/src/lib/dependshandler",
        "pat-htmlparser":            "bower_components/patternslib/src/lib/htmlparser",
        "pat-input-change-events":   "bower_components/patternslib/src/lib/input-change-events",
        "pat-jquery-ext":            "bower_components/patternslib/src/core/jquery-ext",
        "pat-logger":                "bower_components/patternslib/src/core/logger",
        "pat-parser":                "bower_components/patternslib/src/core/parser",
        "pat-registry":              "bower_components/patternslib/src/core/registry",
        "pat-remove":                "bower_components/patternslib/src/core/remove",
        "pat-store":                 "bower_components/patternslib/src/core/store",
        "pat-url":                   "bower_components/patternslib/src/core/url",
        "pat-utils":                 "bower_components/patternslib/src/core/utils",

        // Patterns
        "pat-ajax":                  "bower_components/patternslib/src/pat/ajax/ajax",
        "pat-autofocus":             "bower_components/patternslib/src/pat/autofocus/autofocus",
        "pat-autoscale":             "bower_components/patternslib/src/pat/auto-scale/auto-scale",
        "pat-autosubmit":            "bower_components/patternslib/src/pat/auto-submit/auto-submit",
        "pat-autosuggest":           "bower_components/patternslib/src/pat/auto-suggest/auto-suggest",
        "pat-breadcrumbs":           "bower_components/patternslib/src/pat/breadcrumbs/breadcrumbs",
        "pat-bumper":                "bower_components/patternslib/src/pat/bumper/bumper",
        "pat-carousel":              "bower_components/patternslib/src/pat/carousel/carousel",
        "pat-checkedflag":           "bower_components/patternslib/src/pat/checked-flag/checked-flag",
        "pat-checklist":             "bower_components/patternslib/src/pat/checklist/checklist",
        "pat-chosen":                "bower_components/patternslib/src/pat/chosen/chosen",
        "pat-clone":                 "bower_components/patternslib/src/pat/clone/clone",
        "pat-collapsible":           "bower_components/patternslib/src/pat/collapsible/collapsible",
        "pat-content-mirror":        "bower_components/pat-content-mirror/src/pat-content-mirror",
        "pat-colour-picket":         "bower_components/patternslib/src/pat/colour-picker/colour-picker",
        "pat-depends":               "bower_components/patternslib/src/pat/depends/depends",
        "pat-equaliser":             "bower_components/patternslib/src/pat/equaliser/equaliser",
        "pat-expandable":            "bower_components/patternslib/src/pat/expandable-tree/expandable-tree",
        "pat-focus":                 "bower_components/patternslib/src/pat/focus/focus",
        "pat-form-state":            "bower_components/patternslib/src/pat/form-state/form-state",
        "pat-forward":               "bower_components/patternslib/src/pat/forward/forward",
        "pat-calendar":              "bower_components/patternslib/src/pat/calendar/calendar",
        "pat-gallery":               "bower_components/patternslib/src/pat/gallery/gallery",
        "pat-image-crop":            "bower_components/patternslib/src/pat/image-crop/image-crop",
        "pat-inject":                "bower_components/patternslib/src/pat/inject/inject",
        "pat-legend":                "bower_components/patternslib/src/pat/legend/legend",
        "pat-markdown":              "bower_components/patternslib/src/pat/markdown/markdown",
        "pat-masonry":               "bower_components/patternslib/src/pat/masonry/masonry",
        "pat-menu":                  "bower_components/patternslib/src/pat/menu/menu",
        "pat-modal":                 "bower_components/patternslib/src/pat/modal/modal",
        "pat-navigation":            "bower_components/patternslib/src/pat/navigation/navigation",
        "pat-notification":          "bower_components/patternslib/src/pat/notification/notification",
        "pat-placeholder":           "bower_components/patternslib/src/pat/placeholder/placeholder",
        "pat-raptor":                "bower_components/pat-raptor/src/pat-raptor",
        "pat-resourcepolling":       "bower_components/pat-resourcepolling/src/pat-resourcepolling",
        "pat-selectbox":             "bower_components/patternslib/src/pat/selectbox/selectbox",
        "pat-slides":                "bower_components/patternslib/src/pat/slides/slides",
        "pat-slideshow-builder":     "bower_components/patternslib/src/pat/slideshow-builder/slideshow-builder",
        "pat-sortable":              "bower_components/patternslib/src/pat/sortable/sortable",
        "pat-stacks":                "bower_components/patternslib/src/pat/stacks/stacks",
        "pat-subform":               "bower_components/patternslib/src/pat/subform/subform",
        "pat-switch":                "bower_components/patternslib/src/pat/switch/switch",
        "pat-toggle":                "bower_components/patternslib/src/pat/toggle/toggle",
        "pat-tooltip":               "bower_components/patternslib/src/pat/tooltip/tooltip",
        "pat-upload":                "bower_components/pat-upload/src/pat-upload",
        "pat-validate":              "bower_components/patternslib/src/pat/validate/validate",
        "pat-zoom":                  "bower_components/patternslib/src/pat/zoom/zoom",
        "patterns":                  "patterns",

        // Templates for pat-upload
        "preview":  "bower_components/pat-upload/src/templates/preview.xml",
        "upload":   "bower_components/pat-upload/src/templates/upload.xml",

        //Calendar Pattern
        "moment":           "bower_components/moment/moment",
        "moment-timezone":  "bower_components/moment-timezone/moment-timezone",
        "pat-calendar-moment-timezone-data": "bower_components/pat-calendar/src/moment-timezone-data",

        // Pat Masonry
        "doc-ready":            "bower_components/doc-ready",
        "eventEmitter":         "bower_components/eventEmitter",
        "eventie":              "bower_components/eventie",
        "get-size":             "bower_components/get-size",
        "get-style-property":   "bower_components/get-style-property",
        "imagesloaded":         "bower_components/imagesloaded/imagesloaded",
        "masonry":              "bower_components/masonry/masonry",
        "matches-selector":     "bower_components/matches-selector",
        "outlayer":             "bower_components/outlayer",

        "mockup-parser":            "bower_components/mockup-core/js/parser",
        "mockup-patterns-base":     "bower_components/mockup-core/js/pattern",
        "pikaday":                  "bower_components/pikaday/pikaday",
        "pikaday.jquery":           "bower_components/pikaday/plugins/pikaday.jquery"
    },

    "shim": {
        "fine-uploader": { "depends": "jQuery" },
        "jquery": { "exports": "jQuery" },
        "jquery.fullcalendar.dnd": { "depends": "jQuery" },
        "photoswipe": { "depends": "klass" },
        "rangy": { "exports": "rangy" },
        "rangy-cssclassapplier": { "deps": ["rangy"] },
        "rangy-selectionsaverestore": { "deps": ["rangy"] },
        "rangy-serializer": { "deps": ["rangy"] },
        "jquery-hotkeys": { "deps": ["jquery"] }
    },
    "optimize": "none"
}
