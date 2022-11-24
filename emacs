;; ======================================================================= ;;;
;;; Author: Le Pan
;;; Reversion: 1.0
;;; Update: 2016/10/11
;;; ======================================================================= ;;;

;;; split the previous version to several parts; do NOT use byte
;;; compile anymore; all extra libraries except those with distro
;;; binaries will be put into ${HOME}/.emacs.d/site-lisp/
;;; Use this file on Ubuntu 14.04 with following package installed
;;; emacs cscope w3m

;;; ======================================================================= ;;;
;;; EXECUTABLE PATH
;;; ======================================================================= ;;;
;;; have a private script directory for emacs only; all utilities will
;;; be put into ~/.emacs.d/scripts
(setenv "PATH" (concat (getenv "PATH") ":~/.emacs.d/scripts"))
(setq exec-path (append exec-path '("~/.emacs.d/scripts")))

;;; ======================================================================= ;;;
;;; LOADPATH
;;; ======================================================================= ;;;
(let ((default-directory "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;;; ======================================================================= ;;;
;;; USER INFO
;;; ======================================================================= ;;;
(setq user-full-name "Le Pan")
(setq user-mail-address "panle41@qq.com")

;;; ======================================================================= ;;;
;;; INITIALIZE PEMACS
;;; ======================================================================= ;;;
(require 'pemacs-init)
(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (docker-compose-mode dockerfile-mode ## flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
