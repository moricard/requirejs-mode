requirejs-mode
==============

requireJS is a Backbone aware minor mode for emacs

The goal is to make writing modules for [requireJS](http://requirejs.org) easier and more
productive.

## Installation

It is available on the [marmalade-repo](http://marmalade-repo.org), so if you use ELPA:

```
package-install requirejs-mode
```

Otherwise, make sure you put the `requirejs-mode.el` in your load path.

Then in your `init.el` file.

```
(require 'requirejs-mode)
```

If you would like to automatically load requireJs mode when editing javascript, you can put the
following in your `init.el`. Replace `js2-mode-hook` by `javascript-mode-hook` if you don't use
js2-mode.

```
(add-hook 'js2-mode-hook (lambda () (requirejs-mode)))
```

## Keybindings

* `C-c rf` : require-import-file
* `C-c rc` : require-create
* `C-c ra` : require-import-add

## Functions

### `require-import-file`

Importing file as a module is *Backbone aware* in the sense that it will try to keep the
subfolders of the imported files only if these are below `.../collections/`, `.../views/`,
`.../models/`, `.../templates/`.

For example, importing a file with the relative path `../collections/books.js` from a module
will put `'collections/books'` in the dependencies list and `'Books'` in the function declaration.

It will also prepend `text!` in the dependencies list item if the file loaded is a template.

### `require-import-add`

This mode keeps track of all files imported as a dependency within an Emacs session. So
a common dependency, such as jquery, underscore, backbone, or any you have already 
imported in your session will be available with this function.

Dependencies are stored as an associative list, so choosing an item from the list will
put it's dependency name in the list and it's function variable name in the module's
function definition.

Current defaults:

* `jquery` : `$`
* `underscore` : `_`
* `backbone` : `Backbone`

### `require-create`

Creates an empty AMD module.

Explicitly, generates:

```
define (
    [],
    
    function ( ) {
        
    }
);
```

Note that it is not necessary to create an empty module before importing dependencies
as it will be created by default if it is not present.

## Dependencies

No dependencies, but it will use `ido` to auto-complete prompts if it is present.

## Issues

If you find bugs or you would like new features to be implemented, use the [issue
tracker](https://github.com/ricardmo/requirejs-mode/issues), or better, make a
pull request with the fixes.

## License
Copyright (C) 2013 Marc-Olivier Ricard

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
