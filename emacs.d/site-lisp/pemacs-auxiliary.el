;;; Enabling indexing xcscope
;; cscope package is required
(unless (eq system-type 'windows-nt)
  (require 'xcscope))

;; projects
(require 'eproject)

(provide 'pemacs-auxiliary)
