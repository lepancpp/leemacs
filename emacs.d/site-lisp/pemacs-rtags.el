;; rtags
(require 'rtags)
(rtags-enable-standard-keybindings)

(define-key c-mode-base-map (kbd "M-.") (function rtags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "M-,") (function rtags-find-references-at-point))
(define-key c-mode-base-map (kbd "M-?") (function rtags-display-summary))
(define-key c-mode-base-map (kbd "M-;") (function rtags-find-file))

(define-key c-mode-base-map (kbd "M-[") (function rtags-location-stack-back))
(define-key c-mode-base-map (kbd "M-]") (function rtags-location-stack-forward))


(define-key c-mode-base-map (kbd "C-.") (function rtags-compile-file))
(define-key c-mode-base-map (kbd "C-,") (function rtags-diagnostics))
(define-key global-map (kbd "C-.") (function rtags-compile-file))
(define-key global-map (kbd "C-,") (function rtags-diagnostics))

(require 'company-rtags)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
(global-company-mode)
(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))

(require 'flycheck-rtags)
(setq rtags-autostart-diagnostics t)
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
(add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)

(require 'helm-rtags)
(setq rtags-display-result-backend 'helm)

(provide 'pemacs-rtags)
