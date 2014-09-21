;;; dts-mode.el --- A major emacs mode for editing Devicetree source code

;; Version: 0.1.0
;; Author: Ben Gamari <ben@smart-cactus.org>
;; Url: http://github.com/bgamari/dts-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License version 2 as
;; published by the Free Software Foundation.

(defconst dts-re-ident "[[:word:]_][[:word:][:multibyte:]_,[:digit:]-]*")
(defun dts-re-word (inner) (concat "\\<" inner "\\>"))
(defun dts-re-grab (inner) (concat "\\(" inner "\\)"))

(defvar dts-mode-font-lock-keywords
  `(
    ;; names like `name: hi {`
    (,(concat (dts-re-grab dts-re-ident) ":") 1 font-lock-variable-name-face)
    ;; nodes
    (,(concat (dts-re-grab dts-re-ident) "\\(@[[:xdigit:]]+\\)?[[:space:]]*{") 1 font-lock-type-face)
    ;; assignments
    (,(concat (dts-re-grab dts-re-ident) "[[:space:]]*=") 1 font-lock-variable-name-face)
    (,(concat (dts-re-grab dts-re-ident) "[[:space:]]*;") 1 font-lock-variable-name-face)
    ;; references
    (,(concat "\\&" (dts-re-grab dts-re-ident)) 1 font-lock-variable-name-face)
    )
  )

(defvar dts-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?<  "(" table)
    (modify-syntax-entry ?>  ")" table)

    (modify-syntax-entry ?&  "." table)
    (modify-syntax-entry ?|  "." table)
    (modify-syntax-entry ?&  "." table)
    (modify-syntax-entry ?~  "." table)

    ;; _ and , are both word characters
    (modify-syntax-entry ?,  "_" table)
    (modify-syntax-entry ?_  "w" table)

    ;; Strings
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)

    ;; Comments
    (modify-syntax-entry ?/  ". 124b" table)
    (modify-syntax-entry ?*  ". 23"   table)
    (modify-syntax-entry ?\n "> b"    table)
    (modify-syntax-entry ?\^m "> b"   table)

    table))

(define-derived-mode dts-mode prog-mode "Devicetree"
  "Major mode for editing Devicetrees"
  :group 'dts-mode
  :syntax-table dts-mode-syntax-table

  ;; Fonts
  (setq-local font-lock-defaults '(dts-mode-font-lock-keywords nil nil nil nil))

  (setq-local comment-start "/* ")
  (setq-local comment-end   " */")
  (setq-local indent-tabs-mode nil)
  (setq-local comment-multi-line t)
)

(provide 'dts-mode)

(add-to-list 'auto-mode-alist '("\\.dts\\'" . dts-mode))
(add-to-list 'auto-mode-alist '("\\.dtsi\\'" . dts-mode))

;;; dts-mode.el ends here
