;;;;;;;;;;;;;;;;;;;;;;;;;;;; package managing ;;;;;;;;;;;;;;;;;;;;;;;;;
                           ;; use package ;;
;; This is only needed once, near the top of the file
(eval-when-compile
  (require 'use-package))

                             ;; melpa ;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dash ;;
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)))

                              ;; tabs ;;
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("s-b" . centaur-tabs-backward)
  ("s-f" . centaur-tabs-forward))
(setq centaur-tabs-style "bar")
(centaur-tabs-headline-match)


                         ;; fuzzy search ;;
;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

                           ;; powerline ;;
(use-package powerline
  :ensure t)
(powerline-default-theme)

                        ;; dim fake buffers ;;
;;(require solaire-mode)
(solaire-global-mode +1)

                        ;; literate calc mode ;;
(use-package literate-calc-mode
  :ensure t)

                        ;; keep code indented ;;
(use-package aggressive-indent
  :ensure t)
(add-hook 'prog-mode-hook 'aggressive-indent-mode)

                     ;; highlight code indenting ;;
(use-package highlight-indent-guides
  :ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)

                           ;; highlight symbols ;;
(use-package idle-highlight-mode
  :ensure t
  :config (setq idle-highlight-idle-time 0.2))

  ;; :hook ((prog-mode text-mode) . idle-highlight-mode))

                           ;; multiple cursors ;;

(use-package multiple-cursors
  :ensure t)
;; add multiple cursors to all selected lines
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; add multiple cursors to next same word
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

                             ;; real clipboard ;;
(use-package simpleclip
  :ensure t)
(simpleclip-mode 1)
;; use s-c, s-x, s-v

                             ;; drag stuff ;;
(use-package drag-stuff
  :ensure t)
(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

                       ;; capitalize and lowercase words;;
(use-package fix-word
  :ensure t)
(global-set-key (kbd "M-u") #'fix-word-upcase)
(global-set-key (kbd "M-l") #'fix-word-downcase)
(global-set-key (kbd "M-c") #'fix-word-capitalize)

                            ;; comment lines ;;
(use-package evil-nerd-commenter
  :ensure t)
(evilnc-default-hotkeys t)
;; M-;

                            ;; project management;;
(use-package projectile
  :ensure t)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(use-package neotree
  :ensure t)
(global-set-key [f8] 'neotree-toggle)

                               ;; better dired ;;
(use-package dirvish
  :ensure t)
(dirvish-override-dired-mode)

;; pdf tools
(use-package pdf-tools
  :ensure t)

;; hide emacs recover session files
(defun enable-dired-omit-mode () (dired-omit-mode 1))
(add-hook 'dired-mode-hook 'enable-dired-omit-mode)

(defadvice recover-session (around disable-dired-omit-for-recover activate)
  (let ((dired-mode-hook dired-mode-hook))
    (remove-hook 'dired-mode-hook 'enable-dired-omit-mode)
    ad-do-it))

;; toggle showing dot files
(defun dired-dotfiles-toggle ()
  "Show/hide dot-files"
  (interactive)
  (when (equal major-mode 'dired-mode)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
	(progn 
	  (set (make-local-variable 'dired-dotfiles-show-p) nil)
	  (message "h")
	  (dired-mark-files-regexp "^\\\.")
	  (dired-do-kill-lines))
      (progn (revert-buffer) ; otherwise just revert to re-show
	     (set (make-local-variable 'dired-dotfiles-show-p) t)))))

                            ;; magit ;;
(use-package magit
  :ensure t)

                          ;; good terminal;;
;; (use-package vterm
;;     :ensure t)

                        ;; code highlighting ;;
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

                         ;; code completion ;;
(use-package auto-complete
  :ensure t)
(ac-config-default)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; extra config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; moe theme
(use-package moe-theme
  :ensure t)
(load-theme 'moe-light t)

;; (use-package poet-theme
;;   :ensure t)
;; (load-theme 'poet t)
;; (add-hook 'text-mode-hook
;;           (lambda ()
;;             (variable-pitch-mode 1)))
;; (set-face-attribute 'default nil :family "DejaVu Sans Mono")
;; (set-face-attribute 'fixed-pitch nil :family "DejaVu Sans Mono")
;; (set-face-attribute 'variable-pitch nil :family "NotoSerif")

;; get rid of splash screen
;; and flash when the bell rings
(setq inhibit-startup-message t
      visible-bell t)

;; turn off menu ui
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; no more bad indenting
;;(electric-indent-mode -1)

;; delete selected text when you type
(delete-selection-mode +1)

;; automatic delimiters like ()
(electric-pair-mode +1)

;; show line numbers
(display-line-numbers-mode +1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; default stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(centaur-tabs use-package dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
