;disable auto indenting on paste
(electric-indent-mode -1)
;disable backup
(setq backup-inhibited t)
;disable auto save
(setq auto-save-default nil)
;enable auto-revert buffer
(global-auto-revert-mode 1)
;set default fill-column for line wrapping
(setq-default fill-column 79)
;enable column number mode
(setq column-number-mode t)

;; elpa
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
;; M-x package-install
;; go-mode
;; M-x go-mode

;; M-x package-install
;; column-enforce-mode
;; M-x column-enforce-mode

(put 'upcase-region 'disabled nil)

; set javascript indent to 2 spaces
(setq js-indent-level 2)