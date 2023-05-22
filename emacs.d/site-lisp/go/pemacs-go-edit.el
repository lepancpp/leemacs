
(require 'go-mode)

(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-to-list 'exec-path "/lib/go-1.13/bin")
(setenv "GO111MODULE" "on")

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(provide 'pemacs-go-edit)
