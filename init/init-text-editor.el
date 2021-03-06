(use-package persistent-scratch
  
  :defer 0.2
  :config
  (persistent-scratch-setup-default))

(use-package tex
  
  :straight (auctex :host github :repo "raxod502/auctex"
                    :branch "fork/1"
                    :files (:defaults (:exclude "doc/*.texi")))

  :mode ("\\.tex\\'" . TeX-latex-mode)

  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (font-latex-fontify-script nil)
  (preview-image-type 'imagemagick)
  (reftex-plug-into-AUCTeX t)
  (TeX-PDF-mode nil)
  (reftex-plug-into-AUCTeX t)
  (LaTeX-electric-left-right-brace t)
  (TeX-master nil)

  :config
  (progn
    (fset 'tex-font-lock-suscript 'ignore)
    (require 'smartparens-latex)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
    (add-hook 'LaTeX-mode-hook '(lambda () (setq compile-command "latexmk -pdf")))
    (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ))

(use-package magic-latex-buffer
  
  :hook LaTeX-mode)

(use-package cdlatex
  
  :commands (turn-on-cdlatex cdlatex-mode))

(use-package org-version
  
  :straight nil
  :load-path "lib/")

(use-package org

  :mode ("\\.org\\'" . org-mode)

  :hook ((org-mode . turn-on-org-cdlatex))

  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-o" . org-clock-out))

  :custom-face
  (org-block                 ((t (:background "#424242"))))
  (org-block-begin-line      ((t (:background nil :height 0.95 :foreground "grey70"))))
  (org-block-end-line        ((t (:background nil :height 0.95 :foreground "grey70"))))

  :custom
  (org-imenu-depth 3 "Three-level entries in imenu-list")
  
  :init
  (setq org-directory "~/Dropbox/Org"
	org-default-notes-file (concat org-directory "/notes.org")
	org-agenda-files (list "~/Dropbox/Org")
	org-refile-targets '((org-agenda-files :maxlevel . 3))
	org-capture-templates (quote (("t" "TODO" entry (file+olp+datetree "~/Dropbox/Org/captures.org")
				       "* TODO %?")
				      ("m" "Mail-to-do" entry (file+headline "~/Dropbox/Org/captures.org" "Tasks")
				       "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
				      ("a" "Appointment" entry (file+olp+datetree "~/Dropbox/Org/captures.org")
				       "* %?")
				      ("n" "note" entry (file+headline "~/Dropbox/Org/captures.org" "IDEAS")
				       "* %?\nCaptured on %U\n  %i")
				      ("j" "Journal" entry (file+olp+datetree "~/Dropbox/journal.org")
				       "* %?\nEntered on %U\n  %i")))
	org-tag-alist (quote (("BUDD"    . ?b)
			      ("PHIL"    . ?p)
			      ("ENGL"    . ?e)))
	org-todo-keywords '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")
			    (sequence "QUESTION(q)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)"))
	org-log-done 'time
	org-refile-use-outline-path 'file
	org-outline-path-complete-in-steps nil
	org-refile-allow-creating-parent-nodes 'confirm
	truncate-lines nil)

  :config
  (progn
   
    (setq org-preview-latex-default-process 'imagemagick
	  org-image-actual-width (/ (display-pixel-width) 2)
	  org-pretty-entities t		; render UTF8 characters
	  org-pretty-entities-include-sub-superscripts nil
	  org-confirm-babel-evaluate nil
	  org-src-fontify-natively t	; syntax highlight in org mode
	  org-highlight-latex-and-related '(latex) ; org-mode buffer latex syntax highlighting
	  org-footnote-auto-adjust t ; renumber footnotes when new ones are inserted
	  org-export-with-smart-quotes t ; export pretty double quotation marks
	  ispell-parser 'tex
	  org-latex-caption-above '(table image)
	  ;; set value of the variable org-latex-pdf-process
	  org-latex-pdf-process
	  '("xelatex -interaction nonstopmode -output-directory %o %f"
	    "bibtex %b"
	    "xelatex -interaction nonstopmode -output-directory %o %f"
	    "xelatex -interaction nonstopmode -output-directory %o %f"))

    (require 'org-tempo) ;; Easy Templates Expansion
    
    (plist-put org-format-latex-options :scale 1.70) ; bigger latex fragment

    ;; a font-lock substitution for list markers 
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    (add-hook 'org-babel-after-execute-hook 'org-display-inline-images) ; images auto-load

    ;; Automatically turn on hl-line-mode inside org-mode tables
    (defun highlight-current-table-line ()
      (interactive)
      (if (org-at-table-p)
	  (hl-line-mode 1)
	(hl-line-mode -1)))

    (defun setup-table-highlighting ()
      (add-hook 'post-command-hook #'highlight-current-table-line nil t))

    (add-hook 'org-mode-hook #'setup-table-highlighting)
    (add-hook 'orgtbl-mode-hook #'setup-table-highlighting)
    
    (require 'smartparens-org)

    (use-package smartparens-Tex-org :straight nil :load-path "lib/")

    ))

(use-package org-auto-formula

  :straight nil
  :load-path "lib/"
  :after org
  :config
  (add-hook 'post-command-hook 'cw/org-auto-toggle-fragment-display))

(use-package org-download
  
  :hook ((org-mode dired-mode) . org-download-enable))

(use-package org-bullets
  
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("◉" "○" "●" "◆" "♦")))

(use-package ox-word

  :straight nil
  :after org
  :load-path "lib/")

;; a WYSiWYG HTML mail editor that can be useful for sending tables, fontified source code, and inline images in email. 
(use-package org-mime
  
  :commands (org-mime-htmlize)

  :custom
  (org-mime-up-subtree-heading 'org-back-to-heading)
  (org-mime-export-options '(:section-numbers nil
					      :with-author nil
					      :with-toc nil
					      :with-latex imagemagick)) )

(use-package org-babel-eval-in-repl
  
  :after ob
  :bind (:map org-mode-map
	      ("C-<return>" . ober-eval-in-repl)
	      ("M-<return>" . ober-eval-block-in-repl)))

(use-package yaml-mode
  
  :mode "\\.yaml\\'")

(use-package markdown-mode
  
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))

  :custom
  (markdown-enable-math t)
  (markdown-command "multimarkdown"))

(use-package writeroom-mode
  
  :commands writeroom-mode

  :hook (org-mode markdown-mode LaTeX-mode)

  :bind (:map writeroom-mode-map
	      ("s-?" . nil)
	      ("C-c m" . writeroom-toggle-mode-line))

  :custom
  (writeroom-fullscreen-effect 'maximized)
  (writeroom-bottom-divider-width 0)
  (writeroom-maximize-window nil)
  (writeroom-width 90))

(use-package ispell

  :straight nil

  :commands ispell

  :custom
  (ispell-program-name (executable-find "hunspell"))
  (ispell-choices-win-default-height 5)
  (ispell-dictionary "en_US")

  :config
  (progn
    (setenv "DICTIONARY" "en_US")
    
    (defun du-org-ispell ()
      "Configure `ispell-skip-region-alist' for `org-mode'."
      (make-local-variable 'ispell-skip-region-alist)
      (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
      (add-to-list 'ispell-skip-region-alist '("~" "~"))
      (add-to-list 'ispell-skip-region-alist '("=" "="))
      ;; this next line approximately ignores org-ref-links
      (add-to-list 'ispell-skip-region-alist '("cite:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("citet" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("citep" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("label:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("ref:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("eqref:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("Cref:" . "[[:space:]]"))
      (add-to-list 'ispell-skip-region-alist '("\\[fn:.+:" . "\\]"))
      (add-to-list 'ispell-skip-region-alist '("^http" . "\\]"))
      (add-to-list 'ispell-skip-region-alist '("- \\*.+" . ".*\\*: "))
      (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC"))
      (add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))) 

    (add-hook 'org-mode-hook #'du-org-ispell)))

(use-package langtool
  
  :commands langtool-check
  :custom
  (langtool-default-language "en-US")
  (langtool-language-tool-jar "/usr/local/Cellar/languagetool/4.1/libexec/languagetool-commandline.jar"))

(use-package pyim
  
  :bind (("M-p" . pyim-convert-code-at-point)
	 ("M-f" . pyim-forward-word)
	 ("M-b" . pyim-backward-word))

  :init
  (progn
    (setq default-input-method "pyim"
	  pyim-default-scheme 'quanpin
	  pyim-page-tooltip 'posframe
	  pyim-page-length 5
	  pyim-dicts
	  '((:name "default" :file "~/pyim-dicts/pyim-bigdict.pyim")
            (:name "eng abbriv" :file "~/pyim-dicts/eng-abbrev.pyim")))
    
    (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  ;pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

    (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation)) )

  :config
  (use-package pyim-basedict
      :config (pyim-basedict-enable)))

(use-package academic-phrases
  
  :commands (academic-phrases academic-phrases-by-section))

(provide 'init-text-editor)
