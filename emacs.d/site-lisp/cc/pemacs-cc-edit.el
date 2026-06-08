;;; pemacs-cc-edit.el --- C/C++ editing: tree-sitter, eglot, clang-format -*- lexical-binding: t; -*-

;;; Commentary:

;; Modern C/C++ setup for Emacs 30+:
;;   - tree-sitter major modes (c-ts-mode / c++-ts-mode)
;;   - code intelligence via the built-in eglot LSP client + clangd
;;     (completion, xref navigation, references, diagnostics, hover)
;;   - company as the completion front-end
;;   - clang-format for formatting (Google style)
;;
;; External tools required (install once):
;;   sudo apt install clangd clang-format cmake
;; Tree-sitter grammars (build once if missing):
;;   M-x treesit-install-language-grammar RET c   RET
;;   M-x treesit-install-language-grammar RET cpp RET
;; clangd needs a compile_commands.json (e.g. `bear -- make`, or
;; `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1`) at the project root.

;;; Code:

(require 'treesit)

;;; --- Tree-sitter grammar sources -------------------------------------------
;; Registered so `treesit-install-language-grammar' can (re)build them.
(dolist (src '((c   "https://github.com/tree-sitter/tree-sitter-c")
               (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  (add-to-list 'treesit-language-source-alist src))

;;; --- Major modes for C/C++ -------------------------------------------------
;; Headers default to C++ (this codebase is C++-first).
(defconst pemacs-c++-file-regexp "\\.\\(cc\\|cpp\\|cxx\\|hpp\\|hh\\|h\\)\\'"
  "File extensions treated as C++ source.")

(if (and (treesit-available-p) (treesit-language-available-p 'cpp))
    ;; Preferred path: tree-sitter modes.
    (progn
      (add-to-list 'auto-mode-alist (cons pemacs-c++-file-regexp 'c++-ts-mode))
      (add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
      ;; Route anything that still opens classic c/c++-mode to the ts modes.
      (add-to-list 'major-mode-remap-alist '(c-mode   . c-ts-mode))
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
      ;; Live indentation ~ Google style: 2-space offset. clang-format remains
      ;; the source of truth for full (re)formatting.
      (setq c-ts-mode-indent-offset 2)
      (setq c-ts-mode-indent-style 'k&r)
      (add-hook 'c-ts-base-mode-hook
                (lambda () (setq fill-column 79))))
  ;; Fallback: classic cc-mode + Google style when grammars are unavailable.
  (require 'google-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
  (add-hook 'c-mode-common-hook (lambda () (setq fill-column 79)))
  (defconst caplab-c-style
    '("Google"
      (c-basic-offset . 2)
      (c-offsets-alist . ((innamespace-open . 0)
                          (innamespace-close . 0)
                          (innamespace . 0)
                          (extern-lang-open . 0)
                          (extern-lang-close . 0)
                          (extern-lang . 0))))
    "Google style with un-indented namespaces/extern blocks.")
  (add-hook 'c++-mode-hook (lambda () (c-add-style "caplab" caplab-c-style)))
  (add-to-list 'auto-mode-alist (cons pemacs-c++-file-regexp 'c++-mode)))

;;; --- Code intelligence: eglot + clangd -------------------------------------
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode c-mode c++-mode)
                 . ("clangd" "--background-index" "--clang-tidy"
                    "--header-insertion=never" "--completion-style=detailed"
                    ;; Let clangd query the real compiler for system include
                    ;; paths so libstdc++/glibc headers resolve in gcc projects.
                    "--query-driver=/usr/bin/g++*,/usr/bin/gcc*,/usr/bin/c++*,/usr/bin/clang*"))))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook c-mode-hook c++-mode-hook))
  (add-hook hook #'eglot-ensure))

;;; --- Completion front-end: company -----------------------------------------
(with-eval-after-load 'company
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook c-mode-hook c++-mode-hook))
  (add-hook hook #'company-mode))

;;; --- Snippets in tree-sitter buffers ---------------------------------------
;; c-ts-mode / c++-ts-mode do not derive from the classic c/c++-mode, so make
;; their snippet tables explicitly available in the tree-sitter buffers.
(add-hook 'c-ts-mode-hook
          (lambda () (when (fboundp 'yas-activate-extra-mode)
                       (yas-activate-extra-mode 'c-mode))))
(add-hook 'c++-ts-mode-hook
          (lambda () (when (fboundp 'yas-activate-extra-mode)
                       (yas-activate-extra-mode 'c++-mode))))

;;; --- Formatting: clang-format ----------------------------------------------
(require 'clang-format)
;; `clang-format-style' is buffer-local; set the default so every buffer
;; gets Google style (plain setq would only affect the load-time buffer).
(setq-default clang-format-style "google")

;;; --- Keybindings (formatting, header/source switch, LSP actions) -----------
(defun pemacs-cc-bind-keys (map)
  "Bind C/C++ editing commands in keymap MAP."
  (define-key map (kbd "C-c i") #'clang-format-region)
  (define-key map (kbd "C-c u") #'clang-format-buffer)
  (define-key map (kbd "C-c o") #'ff-find-other-file)  ; header <-> source
  (define-key map (kbd "C-c r") #'eglot-rename)         ; LSP rename symbol
  (define-key map (kbd "C-c a") #'eglot-code-actions))  ; LSP quick-fix / action

(with-eval-after-load 'c-ts-mode
  (pemacs-cc-bind-keys c-ts-base-mode-map))
(with-eval-after-load 'cc-mode
  (pemacs-cc-bind-keys c-mode-base-map))

;;; --- Adjacent languages ----------------------------------------------------
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

(provide 'pemacs-cc-edit)
;;; pemacs-cc-edit.el ends here
