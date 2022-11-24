;;; edit.el --- Auxillary tools for editing in CC-mode

;; Copyright (C) 2013  Adam Jiang

;; Author: Adam Jiang <jiang.adam@gmail.com>
;; Keywords:

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


(require 'google-c-style)

;; set google-c-style as default when cc-mode is open
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; set width of the line to 79 charactors
(add-hook 'c-mode-common-hook
	  '(lambda () (setq-default fill-column 79)))

;; define caplab-c-style
(defconst caplab-c-style
  '("Google"
    (c-basic-offset . 2)
    (c-offsets-alist . (((innamespace-open . 0)
			 (innamespace-close . 0)
			 (innamespace . 0)
			 (extern-lang-open . 0)
			 (extern-lang-close . 0)
			 (extern-lang . 0)
			 )))))

(defun caplab-set-style ()
  (c-add-style "caplab" caplab-c-style))
(add-hook 'c++-mode-hook 'caplab-set-style)

;; treat .h .hpp .cc .cpp file as c++ source code
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))

(require 'protobuf-mode)
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))
(add-hook 'protobuf-mode-hook
	  (lambda () (c-add-style "my-style" my-protobuf-style t)))

(require 'cuda-mode)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(require 'clang-format)
(add-hook 'c-mode-common-hook '(lambda () (global-set-key (kbd "C-c i") 'clang-format-region)))
(add-hook 'c-mode-common-hook '(lambda () (global-set-key (kbd "C-c u") 'clang-format-buffer)))
(setq clang-format-style-option "google")

(provide 'pemacs-cc-edit)
;;; edit.el ends here
