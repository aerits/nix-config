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
  :ensure t
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
(use-package solaire-mode
  :ensure t)
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
  :config (setq idle-highlight-idle-time 0.2)
  :hook ((prog-mode text-mode) . idle-highlight-mode))

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
;; (defun enable-dired-omit-mode () (dired-omit-mode 1))
;; (add-hook 'dired-mode-hook 'enable-dired-omit-mode)

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
(use-package vterm
  :ensure t)

;; code highlighting ;;
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
(use-package slime
  :ensure t)
(setq inferior-lisp-program "sbcl")

;; code completion ;;
(use-package auto-complete
  :ensure t)
(ac-config-default)

;; icons ;;
(use-package nerd-icons
  :ensure t
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package meow
  :ensure t)
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill) 
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))
(meow-setup)
(meow-global-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ox-ioslide
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; gnus ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq user-mail-address	"utu.jin@disroot.org"
      user-full-name	"utu.jin")

(setq gnus-select-method '(nnrss "https://reddit.com/r/emacs.rss"))

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
(global-display-line-numbers-mode +1)

;; tabs
(setq tab-width 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; default stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(speed-type centaur-tabs use-package dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
