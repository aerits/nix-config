;;;;;;;;;;;;;;;;;;;;;;;;;;; package managing ;;;;;;;;;;;;;;;;;;;;;;;;;
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
  ("C-x c p" . centaur-tabs-backward)
  ("C-x c n" . centaur-tabs-forward))
(global-set-key (kbd "C-x c p") 'centaur-tabs-backward)
(global-set-key (kbd "C-x c n") 'centaur-tabs-forward)
(setq centaur-tabs-cycle-scope 'tabs)
(global-set-key (kbd "C-x c g") 'centaur-tabs-toggle-groups)
(defun eaf-goto-right-tab ()
  (centaur-tabs-forward))
(defun eaf-goto-left-tab ()
  (centaur-tabs-backward))

(setq centaur-tabs-style "bar")

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
;; (use-package powerline
;;   :ensure t)
;; (powerline-default-theme)
(use-package telephone-line
  :ensure t)
;; (telephone-line-mode 1)
(use-package mood-line
  :ensure t)
(mood-line-mode)

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
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
	      ("C-c C-e" . markdown-do)))

;; error check ;;
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
;; lsp ;;
(use-package eglot
  :ensure t
  :hook
  ((python-mode . eglot-ensure)
   (nix-mode . eglot-ensure))
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  :hook
  (nix-mode . eglot-ensure))
;; code completion ;;
(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-exclude-modes'.
  :init
  (global-corfu-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

;; tree sitter
(use-package tree-sitter
  :ensure t)
(use-package tree-sitter-langs
  :ensure t)
(use-package tree-sitter-indent
  :ensure t)

;; rainbow () [] {} to make it easier to read
(use-package rainbow-delimiters
  :ensure t)

;; icons ;;
(use-package nerd-icons
  :ensure t
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

;; latex preview
(use-package auctex
  :ensure t)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(setq TeX-PDF-mode t)

;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;; emacs multimedia
(use-package emms
  :ensure t)
(emms-all)
(setq emms-player-list '(emms-player-mpv)
      emms-info-functions '(emms-info-native))

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
   ;; SELF CONFIG FOR MEOW NORMAL MODE
   '("/" . enlarge-window)
   '("?" . enlarge-window-horizontally)
   ;; DEFAULT CONFIG FOR MEOW NORMAL MODE
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

(with-eval-after-load 'org (global-org-modern-mode))

;; better window navigation
;; (global-set-key "\s-j" windmove-left)
;; (global-set-key "\s-k" windmove-down)
;; (global-set-key "\s-l" windmove-up)
;; (global-set-key "\s-;" windmove-right)

;; emacs-everywhere
(use-package emacs-everywhere
  :ensure t)

;; edit with emacs in firefox
(use-package edit-server
  :ensure t
  :commands edit-server-start
  :init (if after-init-time
            (edit-server-start)
          (add-hook 'after-init-hook
                    #'(lambda() (edit-server-start))))
  :config (setq edit-server-new-frame-alist
                '((name . "Edit with Emacs FRAME")
                  (top . 200)
                  (left . 200)
                  (width . 80)
                  (height . 25)
                  (minibuffer . t)
                  (menu-bar-lines . t)
                  (window-system . x))))

;; read epubs
(use-package nov
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; eaf
(use-package eaf
  :load-path "~/.emacs.d/site-lisp/emacs-application-framework"
  :config
  (require 'eaf-browser)
  (require 'eaf-video-player))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; slides
(use-package ox-ioslide
  :ensure t)

;; fancy org mode
(use-package org-modern
  :ensure t)

;; org babel
(add-to-list 'load-path "~/.emacs.d/site-lisp/ob-nix")
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (nix . t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; elfeed ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package elfeed
  :ensure t)
(global-set-key (kbd "C-x w") 'elfeed)
(setf url-queue-timeout 30)
(use-package elfeed-org
  :ensure t)
(elfeed-org)
(setq rmh-elfeed-org-files (list "/etc/nixos/elfeed.org"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; custom funcs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; better novelupdates rss - mark novelupdates chapters fromm elfeed as read
;; get out of here flycheck smh this is good code
(defun nu-read ()
  "mark novelupdates chapter as read
  in the elfeed entry and navigate
  to the chapter in eww"
  (interactive)
  (progn (re-search-forward "novelupdates.com/series")
	 (setq series (thing-at-point 'url))
	 ;; (message series)
	 (re-search-backward "novelupdates.com/extnu")
	 (setq chapter (thing-at-point 'url))
	 ;; (message chapter)
	 (message
	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
					   (concat series
						   (concat " " chapter)))))
	 (eww (thing-at-point 'url))))
(defun nu-read-eaf ()
  "same thing as last function
  except do it with eaf's browser"
  (interactive)
  (progn (re-search-forward "novelupdates.com/series")
	 (setq series (thing-at-point 'url))
	 ;; (message series)
	 (re-search-backward "novelupdates.com/extnu")
	 (setq chapter (thing-at-point 'url))
	 ;; (message chapter)
	 (message
	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
					   (concat series
						   (concat " " chapter)))))
	 (eaf-open-browser (thing-at-point 'url))))
(defun nu-mark-read ()
  "do the same thing as the last
  function except without eww"
  (interactive)
  (progn (re-search-forward "novelupdates.com/series")
	 (setq series (thing-at-point 'url))
	 ;; (message series)
	 (re-search-backward "novelupdates.com/extnu")
	 (setq chapter (thing-at-point 'url))
	 ;; (message chapter)
	 (message
	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
					   (concat series
						   (concat " " chapter)))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; extra config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fonts
;; (set-frame-font "Inconsolata Nerd Font-11" nil t)
;; (set-face-attribute 'variable-pitch nil :font "DejaVu Sans-10")
(set-fontset-font "fontset-default" 'han "Noto Sans CJK JP-11")
(set-fontset-font "fontset-default" 'kana "Noto Sans CJK JP-11")

;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

;; ;; moe theme
;; (use-package moe-theme
;;   :ensure t)
;; (load-theme 'moe-light t)

;; spacemacs theme
(use-package spacemacs-theme
  :ensure t)
(load-theme 'spacemacs-light)

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
