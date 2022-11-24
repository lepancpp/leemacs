;; This file is a great big shotcurt for all the features contained in
;; pemacs

;; Trick to get the filename of the installation directory
(defconst pemacs-install-dir
  (file-name-directory
   (or load-file-name
       (when (boundp 'bytecomp-filename) bytecomp-filename)
       buffer-file-name))
  "Installation directory of pemacs"
  )

(add-to-list 'load-path pemacs-install-dir)
(require 'pemacs-misc)
(require 'pemacs-apperance)
(require 'pemacs-buffer)
(require 'pemacs-browsing)
(require 'pemacs-editing)
(require 'pemacs-completing)
(require 'pemacs-vcs)
(require 'pemacs-auxiliary)

;; for each major mode
(require 'pemacs-cc-edit)
(require 'pemacs-python-edit)

(require 'groovy-mode)
(require 'jenkinsfile-mode)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(require 'cmake-mode)

(require 'pemacs-filemanage)
(require 'pemacs-rtags)

(provide 'pemacs-init)


(require 'package)
(add-to-list 'package-archives
             '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
