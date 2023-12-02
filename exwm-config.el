;;;;;;;;;;;;;;;;;;;;;;;;;;;;; exwm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'exwm-config)

(use-package exwm
  :ensure t)

;; emacs load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Place to put local packages.
(let* ((path (expand-file-name "lisp" user-emacs-directory))
       (local-pkgs (mapcar 'file-name-directory (directory-files-recursively path "\\.el$"))))
  (if (file-accessible-directory-p path)
      (mapc (apply-partially 'add-to-list 'load-path) local-pkgs)
    (make-directory path :parents)))

(autoload 'volume "volume"
  "Tweak your sound card volume." t)

(display-time-mode 1)
(display-battery-mode 1)


;; name x applications
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

;; desktop environment
(use-package desktop-environment)
(desktop-environment-mode)

;; emacs for text input everywhere
(use-package emacs-everywhere
  :ensure t)

;; exwm keybinding
(setq exwm-workspace-number 9)
(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset)
	([?\s-w] . exwm-workspace-switch)
	,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))

	([?\s-&] . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))
	([?\s-j] . windmove-left)
	([?\s-k] . windmove-down)
	([?\s-l] . windmove-up)
	([?\s-\;] . windmove-right)

	([?\s-e] . (start-process-shell-command "emacseverywhere" "emacseverywhere" "emacsclient --eval '(emacs-everywhere)'"))

	([?\s-L] . desktop-environment-lock-screen)

	([?\C-+] . exwm-input-grab-keyboard)

	([?\s-d] . e-run-command)
	
	([?\s-/] . enlarge-window)
	([?\s-.] . shrink-window)
	([?\s-?] . enlarge-window-horizontally)
	([?\s->] . shrink-window-horizontally)

	))

(setq exwm-input-simulation-keys
      '(
        ;; movement
        ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ([?\C-s] . [?\C-f])))

(define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
(define-key exwm-mode-map [?\C-c \C-f] 'exwm-layout-set-fullscreen)
(define-key exwm-mode-map [?\C-c \C-h] 'exwm-floating-hide)
(define-key exwm-mode-map [?\C-c \C-k] 'exwm-input-release-keyboard)
(define-key exwm-mode-map [?\C-c \C-t \C-f] 'exwm-floating-toggle-floating)
(define-key exwm-mode-map [?\C-c \C-t \C-m] 'exwm-layout-toggle-mode-line)

(require 'exwm-config)

(require 'exwm-systemtray)
(exwm-systemtray-enable)

(exwm-enable)

(start-process-shell-command "wifitray" "wifitray" "nm-applet &")
(start-process-shell-command "soundtray" "soundtray" "pasystray &")


;; run stuff
(defun e-run-command ()
  (interactive)
  (require 'subr-x)
  (start-process "RUN" "RUN" (string-trim-right (read-shell-command "RUN: "))))

;; keybinds
;; (setq exwm-input-global-keys `(,(kbd "s-d") .
;;                                (lambda (command)
;;                                  (interactive (list (read-shell-command "$ ")))
;;                                  (start-process-shell-command command nil command))))
