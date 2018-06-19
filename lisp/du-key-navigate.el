(use-package key-chord
  :ensure t
  :commands key-chord-mode)

(use-package which-key
      :ensure t
      :diminish which-key-mode
      :config
      (progn
	(which-key-mode)
	(which-key-setup-side-window-right-bottom)))

(use-package evil
  :ensure t
  :diminish evil-mode
  :init
  (progn
    (setq evil-want-integration nil) 
    (use-package evil-leader
      :ensure t
      :init (global-evil-leader-mode)
      :config
      (progn
	(evil-leader/set-leader "SPC")
	(evil-leader/set-key "wd" 'delete-window)
	(evil-leader/set-key "wo" 'delete-other-windows)
	(evil-leader/set-key "wh" 'split-window-horizontally)
	(evil-leader/set-key "wv" 'split-window-vertically)
	(evil-leader/set-key "ww" 'other-window)
	(evil-leader/set-key "bb" 'ivy-switch-buffer)
	(evil-leader/set-key "bq" 'kill-buffer)
	(evil-leader/set-key "bj" 'next-buffer)
	(evil-leader/set-key "bk" 'previous-buffer)
	(evil-leader/set-key ":" 'counsel-M-x)
	(evil-leader/set-key "ff" 'counsel-find-file)
	(evil-leader/set-key "fr" 'recentf-open-files)
	(evil-leader/set-key "gs" 'magit-status)
	(evil-leader/set-key "gu" 'browse-url-at-point)	
	(evil-leader/set-key "cc" 'evilnc-comment-or-uncomment-lines)
	(evil-leader/set-key "oc" 'org-capture)
	(evil-leader/set-key "oa" 'org-agenda)
	(evil-leader/set-key "ob" 'org-iswitchb)
	(evil-leader/set-key "or" 'org-refile)
	(evil-leader/set-key "ol" 'org-store-link)
	(evil-leader/set-key "oe" 'org-export-dispatch)
	(evil-leader/set-key "of" 'writeroom-mode)
	(evil-leader/set-key "ok" 'org-priority-up)
	(evil-leader/set-key "oj" 'org-priority-down)
	(evil-leader/set-key "ot" 'org-time-stamp)
	(evil-leader/set-key "dd" 'osx-dictionary-search-word-at-point)
	(evil-leader/set-key "di" 'osx-dictionary-search-input)
	(evil-leader/set-key "ej" 'emms-next)
	(evil-leader/set-key "ek" 'emms-previous)
	(evil-leader/set-key "ep" 'emms-pause) )) )
  :config
  (progn
    (evil-mode 1)
    (setq evil-cross-lines t)
    (setq evil-move-cursor-back nil)
    (setq evil-want-C-u-scroll t)
    (setcdr evil-insert-state-map nil)
    (define-key evil-insert-state-map [escape] 'evil-normal-state)
    (evil-add-hjkl-bindings recentf-dialog-mode-map 'emacs)
    (evil-add-hjkl-bindings package-menu-mode-map 'emacs)
    (evil-add-hjkl-bindings pdf-outline-buffer-mode-map 'emacs)
    (evil-add-hjkl-bindings osx-dictionary-mode-map 'emacs)
    (evil-add-hjkl-bindings emms-playlist-mode-map 'emacs)
    
    (defun my-evil-record-macro ()
      (interactive)
      (if buffer-read-only
	  (quit-window)
	(call-interactively 'evil-record-macro)))
    ;; evil quit-window and evil-record-macro integration
    (with-eval-after-load 'evil-maps
      (define-key evil-normal-state-map (kbd "q") 'my-evil-record-macro)) ))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init '(eww eshell cider company dired package-menu)))

(use-package evil-magit
        :ensure t
        :after magit)

(use-package evil-org
    :ensure t
    :diminish evil-org-mode
    :after org
    :config
    (progn
      (add-hook 'evil-org-mode-hook (lambda () (evil-org-set-key-theme)))
      (require 'evil-org-agenda)
      (evil-org-agenda-set-keys)))

(use-package evil-cleverparens
    :ensure t
    :hook (paredit-mode . evil-cleverparens-mode)
    :config (setq evil-cleverparens-swap-move-by-word-and-symbol t))

(use-package evil-paredit
    :ensure t
    :hook (paredit-mode . evil-paredit-mode))

(use-package evil-nerd-commenter
    :ensure t
    :bind ("M-;" . evilnc-comment-or-uncomment-lines))

(use-package evil-mu4e
    :ensure t
    :after mu4e)

(provide 'du-key-navigate)