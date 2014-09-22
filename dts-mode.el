;;; dts-mode.el --- Major mode for Devicetree source code

;; Copyright (C) 2014  Ben Gamari

;; Version: 0.1.0
;; Author: Ben Gamari <ben@smart-cactus.org>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defconst dts-re-ident "\\([[:word:]_][[:word:][:multibyte:]_,[:digit:]-]*\\)")

(defvar dts-mode-font-lock-keywords
  `(
    ;; names like `name: hi {`
    (,(concat dts-re-ident ":") 1 font-lock-variable-name-face)
    ;; nodes
    (,(concat dts-re-ident "\\(@[[:xdigit:]]+\\)?[[:space:]]*{") 1 font-lock-type-face)
    ;; assignments
    (,(concat dts-re-ident "[[:space:]]*=") 1 font-lock-variable-name-face)
    (,(concat dts-re-ident "[[:space:]]*;") 1 font-lock-variable-name-face)
    ;; references
    (,(concat "\\&" dts-re-ident) 1 font-lock-variable-name-face)
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

(defalias 'dts-parent-mode
  (if (fboundp 'prog-mode) 'prog-mode 'fundamental-mode))

;;;###autoload
(define-derived-mode dts-mode dts-parent-mode "Devicetree"
  "Major mode for editing Devicetrees"
  :group 'dts-mode
  :syntax-table dts-mode-syntax-table

  ;; Fonts
  (set (make-local-variable 'font-lock-defaults) '(dts-mode-font-lock-keywords nil nil nil nil))

  (set (make-local-variable 'comment-start) "/* ")
  (set (make-local-variable 'comment-end)   " */")
  (set (make-local-variable 'indent-tabs-mode) nil)
  (set (make-local-variable 'comment-multi-line) t))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dts\\'" . dts-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dtsi\\'" . dts-mode))

(provide 'dts-mode)
;;; dts-mode.el ends here
