
(defvar require-mode-map (make-sparse-keymap)
  "require-mode keymap")

(define-key require-mode-map
  (kbd "C-c rf") 'require-import-file)

(define-key require-mode-map
  (kbd "C-c ra") 'require-import-add)

(define-key require-mode-map
  (kbd "C-c rn") 'require-new-backbone-module)

(define-minor-mode requirejs-mode
  "RequireJS mode

This mode is intended to provide easier management of
dependencies in an AMD style javascript module."

  nil " requireJS" require-mode-map)

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

(defun is-first-import ()
  (looking-back "[\[]" 2))

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

(defun require-create ()
  "initializes an empty requireJS mnodule"
  (interactive)
  (insert "define (
    [],    
    function ( ) {
        
    }
);")
  (backward-char 9))

(defun insert-module (import)
  "Insert import into module header"
  (interactive)

  (save-excursion 
    (if (not (require-goto-headers))
        (require-create))
    (require-goto-dependency-insert-point)
    (let ((is-first (is-first-import)))

      (insert (concat (if is-first "'" ",'") (car import) "'\n    "))
      (require-goto-headers-declaration)
      (insert (concat (if is-first " " ", ") (cdr import))))))


;; Very basic default list of modules
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

    (let ((key import)
          (value (camelize (substring import 0 (string-match "[.]" import)))))

      (insert-module (or (assoc key require-modules)
                         (assoc key (push (cons key value) require-modules)))))))

;; Try to use ido if available but don't whine if not.
(when (require 'ido nil 'noerror)
  (setq ido-present t))

(defun get-file-name (prompt)
  (if ido-present 
      (ido-read-file-name prompt)
    (read-file-name prompt)))

(defun pick-from-list (prompt alist)
  (if ido-present
      (ido-completing-read prompt alist)
    (completing-read prompt alist)))

(defun require-import-file ()
  "add import to require header from ido-file-chooser"
  (interactive)
  (require-import (get-file-name "Import RequireJS module: ")))

(defun require-import-add ()
  "add import to require header from prompted name"
  (interactive)
  (insert-module (assoc (pick-from-list "Use RequireJS module: " require-modules) require-modules)))

(provide 'requirejs-mode)

;;; requirejs-mode.el ends here
