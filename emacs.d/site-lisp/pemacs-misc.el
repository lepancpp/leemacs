;;; ======================================================================= ;;;
;;; MISC SETTINGS
;;; ======================================================================= ;;;
;;; Log async native-compilation warnings quietly instead of popping up the
;;; *Warnings* buffer. The warnings from third-party packages are benign;
;;; they are still recorded in the *Async-native-compile-log* buffer if needed.
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))

(defun mis-setting ()
  (interactive)
  ;;; No startup message
  (setq inhibit-startup-message t)
  ;;; Let scrollbar on right
  (set-scroll-bar-mode 'right)
  ;;; Syntax highlight
  (global-font-lock-mode t)
  ;;; Cursor blink disable
  (blink-cursor-mode -1)
  ;;; Tab block
  (setq x-stretch-cursor t)
  ;;; Disable scratch message
  (setq initial-scratch-message nil)
  ;;; No menu on console
  (or window-system(menu-bar-mode 0))
  ;;(menu-bar-mode 0)
  ;;; No toolbar always
  (tool-bar-mode 0)
  ;;; show paren
  (show-paren-mode 1)
  ;;; Yes to y, No to n
  (fset 'yes-or-no-p 'y-or-n-p)
  ;;; don't blink on parents
  (setq blink-matching-parent nil))

(mis-setting)

(provide 'pemacs-misc)
