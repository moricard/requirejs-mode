(require 'ido)

(defun require-goto-headers ()
  (search-backward-regexp "^define[\s]\(+[\s]*" nil t))

(defun require-goto-function-declaration ()
  (search-forward-regexp "[\s]) {" nil t))

(defun require-goto-headers-declaration ()
  (require-goto-headers)
  (require-goto-function-declaration)
  (backward-char 4))

(defun require-goto-dependency-insert-point ()
  (require-goto-headers)
  (search-forward-regexp "]," nil t)
  (backward-char 2)
)

(defun camelize (s)
      "Convert under_score string S to CamelCase string."
      (mapconcat 'identity (mapcar
                            '(lambda (word) (capitalize (downcase word)))
                            (split-string s "-")) ""))

(defun require-new-jquery-module ()
  "initializes a jquery module"
  (interactive)
  (insert "define (
    ['jquery'
    ],
    
    function ( $ ) {
        
    }
);")
  (backward-char 9))

;; insert a new requireJS module with backbon
(defun require-new-backbone-module ()
  "initializes an empty requireJS mnodule"
  (interactive)
  (insert "define (
    ['jquery'
    ,'underscore'
    ,'backbone'
    ],
    
    function ( $, _, Backbone ) {
        
    }
);")
  (backward-char 9))

(defun require-new-jasmine-module ()
  "inititializes an new jasmine require module"
  (interactive)
  (insert "define (
    ['jasmine'
    ],
    
    function ( Jasmine ) {
        
    }
);")
  (backward-char 9))

(defun require-import (s)
  "add import to require header"
  (interactive)

 (if (setq index (string-match "collections[/.]*[/]" import))
      (setq import (substring import index))
    (if (setq index (string-match "models[/.]*[/]" import))
        (setq import (substring import index))
      (if (setq index (string-match "views[/.]*[/]" import))
          (setq import (substring import index))
        (if (setq index (string-match "templates[/.]*[/]" import))
            (setq import (concat "text!" (substring import index)))
          (setq index (string-match "[a-z]+[\.]js$" import))
          (setq import (substring import index))))))

  (save-excursion 
    (if (not (require-goto-headers))
        (require-new-module))
    (require-goto-dependency-insert-point)
    (insert (concat
             ",'" (substring import 0 (string-match ".js$" import)) "'\n    "))
    (require-goto-headers-declaration)
    (insert (concat
             ", " (camelize (substring import 
                                       (string-match "[a-z-]+[.]" import) 
                                       (string-match "[.]" import))))))
  (message (concat "Adding " import " to dependencies.")))

(defun require-import-file ()
  "add import to require header"
  (interactive)
  ; Get the file-name from interactive do.
  (setq import (ido-read-file-name "Import RequireJS module: "))
  (require-import import))

(defvar require-mode-map (make-sparse-keymap)
  "require-mode keymap")

(define-key require-mode-map
  (kbd "C-c rf") 'require-import-file)

(define-key require-mode-map
  (kbd "C-c rn") 'require-new-backbone-module)

(define-key require-mode-map
  (kbd "C-d rb") 'require-new-backbone-module)

(define-key require-mode-map
  (kbd "C-c r$") 'require-new-jquery-module)

(define-key require-mode-map
  (kbd "C-c rj") 'require-new-jasmine-module)

(define-minor-mode require-mode
  "Require mode" nil " requireJS" require-mode-map)

(provide 'require-mode)

;;; require-mode.el ends here
