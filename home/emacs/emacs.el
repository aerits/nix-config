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

;; usepacakge bind
(use-package bind-key
  :demand t
  :bind
  (:prefix-map rab/files-map
	       :prefix "C-c f")
  :bind
  (:prefix-map rab/toggles-map
	       :prefix "C-c t"))

(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward))

;; dash ;;
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)))

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

;; enhance vertico
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; keep code indented ;;
(use-package aggressive-indent
  :ensure t)
(add-hook 'prog-mode-hook 'aggressive-indent-mode)

;; highlight code indenting ;;
(use-package highlight-indent-guides
  :ensure t)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)

;; multiple cursors ;;
(use-package multiple-cursors
  :ensure t)
;; add multiple cursors to all selected lines
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; add multiple cursors to next same word
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

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

;; magit ;;
(use-package magit
  :ensure t
  :bind
  (
   ("<f12>" . magit-status)
   )
  )

;; good terminal;;
;; (use-package vterm
;;   :ensure t)
(use-package eat
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
;; (use-package eglot
;;   :ensure t
;;   :hook
;;   ((python-mode . eglot-ensure)
;;    (nix-mode . eglot-ensure))
;;   (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
;;   :hook
;;   (nix-mode . eglot-ensure))

;; lsp ;;
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (rust-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; The path to lsp-mode needs to be added to load-path as well as the
;; path to the `clients' subdirectory.
(add-to-list 'load-path (expand-file-name "lib/lsp-mode" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lib/lsp-mode/clients" user-emacs-directory))

;; code completion ;;
(use-package company
  :ensure t)


;; code completion ;;
;; (use-package corfu
;;   :ensure t
;;   ;; Optional customizations
;;   :custom
;;   ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
;;   (corfu-auto t)                 ;; Enable auto completion
;;   ;; (corfu-separator ?\s)          ;; Orderless field separator
;;   ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
;;   ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
;;   (corfu-preview-current nil)    ;; Disable current candidate preview
;;   ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
;;   ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
;;   ;; (corfu-scroll-margin 5)        ;; Use scroll margin

;;   ;; Enable Corfu only for certain modes.
;;   ;; :hook ((prog-mode . corfu-mode)
;;   ;;        (shell-mode . corfu-mode)
;;   ;;        (eshell-mode . corfu-mode))

;;   ;; Recommended: Enable Corfu globally.
;;   ;; This is recommended since Dabbrev can be used globally (M-/).
;;   ;; See also `corfu-exclude-modes'.
;;   :init
;;   (global-corfu-mode))

;; ;; A few more useful configurations...
;; (use-package emacs
;;   :init
;;   ;; TAB cycle if there are only few candidates
;;   (setq completion-cycle-threshold 3)

;;   ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
;;   ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
;;   ;; (setq read-extended-command-predicate
;;   ;;       #'command-completion-default-include-p)

;;   ;; Enable indentation+completion using the TAB key.
;;   ;; `completion-at-point' is often bound to M-TAB.
;;   (setq tab-always-indent 'complete))

;; tree sitter
(use-package tree-sitter
  :ensure t)
(use-package tree-sitter-langs
  :ensure t)
(use-package tree-sitter-indent
  :ensure t)

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
;; (use-package emms
;;   :ensure t)
;; (emms-all)
;; (setq emms-player-list '(emms-player-mpv)
;;       emms-info-functions '(emms-info-native))

;; modal editing
;; (use-package god-mode
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "<escape>") #'god-local-mode)
;;   (define-key god-local-mode-map (kbd ".") #'repeat)
;;   (define-key god-local-mode-map (kbd "[") #'backward-paragraph)
;;   (define-key god-local-mode-map (kbd "]") #'forward-paragraph)
;;   (global-set-key (kbd "C-x C-1") #'delete-other-windows)
;;   (global-set-key (kbd "C-x C-2") #'split-window-below)
;;   (global-set-key (kbd "C-x C-3") #'split-window-right)
;;   (global-set-key (kbd "C-x C-0") #'delete-window)
;;
;;   (require 'god-mode-isearch)
;;   (define-key isearch-mode-map (kbd "<escape>") #'god-mode-isearch-activate)
;;   (define-key god-mode-isearch-map (kbd "<escape>") #'god-mode-isearch-disable))

(use-package evil
  :ensure t
  :init
  (setq evil-disable-insert-state-bindings t)

  :custom
  (evil-motion-state-modes nil)
  (evil-default-state 'emacs)

  :config
  ;; (defalias 'evil-insert-state 'evil-emacs-state)
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map
	      (read-kbd-macro evil-toggle-key) 'evil-emacs-state)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  
  (evil-mode 1))

(use-package consult
  :ensure t
  :bind (
	 ("<f5>" . consult-recent-file)
	 ))

;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; show keys
(use-package which-key
  :ensure t
  :config
  (which-key-enable-god-mode-support))

;; read epubs
(use-package nov
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; eaf
;; (use-package eaf
;;   :load-path "~/.my-emacs/site-lisp/emacs-application-framework"
;;   :config
;;   (require 'eaf-browser)
;;   (require 'eaf-video-player)
;;   (defun eaf-goto-right-tab ()
;;     (centaur-tabs-forward))
;;   (defun eaf-goto-left-tab ()
;;     (centaur-tabs-backward))
;;   (setq eaf-browser-continue-where-left-off t)
;;   (setq eaf-browser-default-search-engine "duckduckgo")
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; slides
(use-package ox-ioslide
  :ensure t)

;; fancy org mode
(use-package org-modern
  :ensure t)

(global-set-key (kbd "C-c l") #'org-store-link)

;; insert images
(use-package org-download
  :ensure t)
(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;; increase size of latex previews
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;; org babel
(add-to-list 'load-path "~/.my-emacs/site-lisp/ob-nix")
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (nix . t)))

(use-package org-fragtog
  :ensure t)

(setq org-startup-with-latex-preview t)

(use-package org-variable-pitch
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-variable-pitch-minor-mode))

;; (setq elfeed-sort-order 'ascending)
;; (global-set-key (kbd "C-'") 'avy-goto-char-timer)
;; (global-set-key (kbd "C-:") 'avy-goto-char)
;; (global-set-key (kbd "M-'") 'avy-goto-line)

;; (run-at-time 5 (* 60 10) 'elfeed-update)

;; drawing svgs

(add-to-list 'load-path "~/.my-emacs/site-lisp/el-easydraw")

(with-eval-after-load 'org
  (require 'edraw-org)
  (edraw-org-setup-default))
;; When using the org-export-in-background option (when using the
;; asynchronous export function), the following settings are
;; required. This is because Emacs started in a separate process does
;; not load org.el but only ox.el.
(with-eval-after-load "ox"
  (require 'edraw-org)
  (edraw-org-setup-exporter))

(use-package obsidian
  :ensure t
  :demand t
  :config
  (obsidian-specify-path "/home/diced/Documents/school files/12th grade/")
  (global-obsidian-mode t)
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-inbox-directory "Inbox")
  :bind (:map obsidian-mode-map
	      ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
	      ("C-c C-o" . obsidian-follow-link-at-point)
	      ;; Jump to backlinks
	      ("C-c C-b" . obsidian-backlink-jump)
	      ;; If you prefer you can use `obsidian-insert-link'
	      ("C-c C-l" . obsidian-insert-wikilink)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; elfeed ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package elfeed
;;   :ensure t)
;; (global-set-key (kbd "C-x w") 'elfeed)
;; (setf url-queue-timeout 30)
;; (use-package elfeed-org
;;   :ensure t)
;; (elfeed-org)
;; (setq rmh-elfeed-org-files (list "/etc/nixos/elfeed.org"))

;; (defun elfeed-save-and-reload ()
;;   (interactive)
;;   (progn (elfeed-db-unload)
;; 	 (elfeed-update)
;; 	 (elfeed-db-save)))

;; (define-key elfeed-search-mode-map "t" 'elfeed-save-and-reload)

;; (setq httpd-host "0.0.0.0")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; custom funcs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; better novelupdates rss - mark novelupdates chapters fromm elfeed as read
;; get out of here flycheck smh this is good code
;; (defun nu-read ()
;;   "mark novelupdates chapter as read
;;   in the elfeed entry and navigate
;;   to the chapter in eww"
;;   (interactive)
;;   (progn (re-search-forward "novelupdates.com/series")
;; 	 (setq series (thing-at-point 'url))
;; 	 ;; (message series)
;; 	 (re-search-backward "novelupdates.com/extnu")
;; 	 (setq chapter (thing-at-point 'url))
;; 	 ;; (message chapter)
;; 	 (message
;; 	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
;; 					   (concat series
;; 						   (concat " " chapter)))))
;; 	 (eww (thing-at-point 'url))))
;; (defun nu-read-eaf ()
;;   "same thing as last function
;;   except do it with eaf's browser"
;;   (interactive)
;;   (progn (re-search-forward "novelupdates.com/series")
;; 	 (setq series (thing-at-point 'url))
;; 	 ;; (message series)
;; 	 (re-search-backward "novelupdates.com/extnu")
;; 	 (setq chapter (thing-at-point 'url))
;; 	 ;; (message chapter)
;; 	 (message
;; 	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
;; 					   (concat series
;; 						   (concat " " chapter)))))
;; 	 (eaf-open-browser (thing-at-point 'url))))
;; (defun nu-mark-read ()
;;   "do the same thing as the last
;;   function except without eww"
;;   (interactive)
;;   (progn (re-search-forward "novelupdates.com/series")
;; 	 (setq series (thing-at-point 'url))
;; 	 ;; (message series)
;; 	 (re-search-backward "novelupdates.com/extnu")
;; 	 (setq chapter (thing-at-point 'url))
;; 	 ;; (message chapter)
;; 	 (message
;; 	  (shell-command-to-string (concat "python ~/Documents/git/better-novelupdates-rss/src/main.py "
;; 					   (concat series
;; 						   (concat " " chapter)))))))

(defun my-insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.
  
  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.
  
  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.
  
  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(global-set-key "\C-c\C-i" 'my-insert-file-name)

;; make it easier to watch youtube in elfeed -- based on browse-url-chrome

(defun browse-url-mpv (url &optional _new-window)
  "Ask the MPV browser to load URL.
Default to the URL around or before point. 
The optional argument NEW-WINDOW is not used."
  (interactive (browse-url-interactive-arg "URL: "))
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply #'start-process
	   (concat "mpv " url) nil
	   "mpv"
	   (list url))))

(setq browse-url-handlers
      '(("invidious.flokinet.to" . browse-url-mpv)
	("." . browse-url-default-browser)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; extra config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fonts
;; (set-frame-font "Inconsolata Nerd Font-11" nil t)
;; (set-face-attribute 'variable-pitch nil :font "DejaVu Sans-10")
(set-fontset-font "fontset-default" 'han "Noto Sans CJK JP-11")
(set-fontset-font "fontset-default" 'kana "Noto Sans CJK JP-11")

;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")
;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")

;; update changed files
(global-auto-revert-mode)

;; spacemacs theme
;; (use-package spacemacs-theme
;;   :ensure t)
;; (load-theme 'spacemacs-light)

(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'latte)
  (catppuccin-reload))

;; get rid of splash screen
;; and flash when the bell rings
(setq inhibit-startup-message t
      visible-bell t)

(keymap-global-set "C-x C-b" 'ibuffer)
(keymap-global-set "C-x b" 'switch-to-buffer)

;; turn off menu ui
(tool-bar-mode -1)
(scroll-bar-mode -1)
(context-menu-mode 1)

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
