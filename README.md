requirejs-mode
==============

requireJS is a Backbone aware minor mode for emacs

The goal is to make writing modules for [requireJS](http://requirejs.org) easier and more
productive.

## Installation

Make sure you put the `requirejs-mode.el` in your load path.

Then in your `init.el` file.

```
(require 'require-mode)
;; replace 'js2-mode-hook with 'js-mode if you don't use js2-mode
(add-hook 'js2-mode-hook
    (lambda ()
        (require-mode)))
```

## Dependencies

We depend on `ido-mode` for the interactive import of a file as a dependency.

## Keybindings

* `C-c rf` : require-import file as module.
* `C-c rn` : require-new-module.
* `C-c rb` : require-new-backbone-module
* `C-c r$` : require-new-jquery-module
* `C-c rj` : require-new-jasmine-module

## Usage

### require-new-module

As it is the one I use the most, this one defaults to `require-new-backbone-module`

### require-new-backbone-module

Generates:

```
define (
    ['jquery'
    ,'underscore'
    ,'backbone'
    ],
    
    function ( $, _, Backbone ) {

    }
);
```

### require-new-jquery-module

Generates:

```
define (
    ['jquery'
    ],
    
    function ( $ ) {
        
    }
);
```

### require-new-jasmine-module

Generates:

```
define (
    ['jasmine'
    ],
    
    function ( Jasmine ) {
        
    }
);
```


### require import file
`M-x require-import`, or `C-c rf`

Importing file as a module is *Backbone aware* in the sense that it will try to keep the
subfolders of the imported files only if these are below `.../collections/`, `.../views/`,
`.../models/`, `.../templates/`.

For example, importing a file with the relative path `../collections/books.js` from a module
will put `'collections/books'` in the dependencies list and `'Books'` in the function declaration.

It will also prepend `text!` in the dependencies list item if the file loaded is a template.
