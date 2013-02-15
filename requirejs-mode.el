(require 'ido)

(defun require-goto-headers ()
  (search-backward-regexp "^define[\s]*(+[\s]*" nil t))

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
      "Convert dash-based string S to CamelCase string."
      (mapconcat 'identity (mapcar
                            '(lambda (word) (capitalize (downcase word)))
                            (split-string s "-")) ""))


(defun un-camelcase-string (s &optional sep start)
  (let ((case-fold-search nil))
    (while (string-match "[A-Z]" s (or start 1))
      (setq s (replace-match (concat (or sep "-") 
                                     (downcase (match-string 0 s))) 
                             t nil s)))
    (downcase s)))

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


(setq require-modules 
      '(("jquery" . "$")
        ("underscore" . "_")
        ("backbone" . "Backbone")))


(defun require-import (s)
  "add import to require header"
  (interactive)
  (message (concat "Adding " s " to dependencies."))
  (let ((import (substring s
                           (or (string-match "collections[/.]*[/]" s)
                               (string-match "models[/.]*[/]" s)
                               (string-match "views[/.]*[/]" s)
                               (string-match "templates[/.]*[/]" s)
                               (string-match "[a-z0-9-]+[.]+[a-z]+$" s)
                               0) 
                           (string-match ".js$" s))))

    (let ((key (un-camelcase-string import))
          (value (camelize (substring import 0 (string-match "[.]" import)))))

      (insert-module (or (assoc key require-modules)
                         (assoc key (push (cons key value) require-modules)))))))

;; (substring 0 (string-match "[.]" import))
(defun insert-module (import)
  "Insert import into module header"
  (interactive)

  (save-excursion 
    (if (not (require-goto-headers))
        (require-new-backbone-module))
    (require-goto-dependency-insert-point) 
    (insert (concat ",'" (car import) "'\n    "))
    (require-goto-headers-declaration)
    (insert (concat ", " (cdr import)))))

(defun require-import-file ()
  "add import to require header from ido-file-chooser"
  (interactive)
  (require-import (ido-read-file-name "Import RequireJS module: ")))

(defun require-import-name ()
  "add import to require header from prompted name"
  (interactive)
  (insert-module (assoc (ido-completing-read "Add RequireJS module: " require-modules) require-modules)))


(defvar require-mode-map (make-sparse-keymap)
  "require-mode keymap")

(define-key require-mode-map
  (kbd "C-c rf") 'require-import-file)

(define-key require-mode-map
  (kbd "C-c ra") 'require-import-name)

(define-key require-mode-map
  (kbd "C-c rn") 'require-new-backbone-module)

(define-key require-mode-map
  (kbd "C-d rb") 'require-new-backbone-module)

(define-key require-mode-map
  (kbd "C-c r$") 'require-new-jquery-module)

(define-minor-mode requirejs-mode
  "RequireJS mode" nil " requireJS" require-mode-map)

(provide 'requirejs-mode)

;;; requirejs-mode.el ends here
