;;; init.el -*- no-byte-compile: t; lexical-binding: t; -*-

(setq inhibit-startup-screen t)
                 
(menu-bar-mode 0)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq package-archive-priorities
      '(("gnu"          . 30)
        ("melpa" . 20)
        ("nongnu"       . 10)))

;;(setq use-package-compute-statistics t)
;;(profiler-start 'cpu)

(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil))

(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)
  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))
  :config
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

(setq auto-save-default t)
(setq auto-save-interval 300)
(setq auto-save-timeout 30)

(use-package corfu
  :commands (corfu-mode global-corfu-mode)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))
  :custom
  (read-extended-command-predicate #'command-completion-default-include-p)
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)
  :config
  (global-corfu-mode))

(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
  :config
  (vertico-mode)
  (setq vertico-count 8))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package prescient
  :ensure t)

(use-package marginalia
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Consult offers a suite of commands for efficient searching, previewing, and
;; interacting with buffers, file contents, and more, improving various tasks.
(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m m" . consult-man)
         ("C-c m i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format))

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-set-key (kbd "C-/") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-/") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))

(use-package buffer-terminator
  :custom
  (buffer-terminator-verbose nil)
  ;; Set the inactivity timeout (in seconds) after which buffers are considered
  ;; inactive (default is 30 minutes):
  (buffer-terminator-inactivity-timeout (* 30 60)) ; 30 minutes
  (buffer-terminator-interval (* 10 60)) ; 10 minutes
  :config
  (buffer-terminator-mode 1))

;; A file and project explorer for Emacs that displays a structured tree
;; layout, similar to file browsers in modern IDEs. It functions as a sidebar
;; in the left window, providing a persistent view of files, projects, and
;; other elements.
(use-package treemacs
  :commands (treemacs
             treemacs-select-window
             treemacs-delete-other-windows
             treemacs-select-directory
             treemacs-bookmark
             treemacs-find-file
             treemacs-find-tag)
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay        0.5
        treemacs-directory-name-transformer      #'identity
        treemacs-display-in-side-window          t
        treemacs-eldoc-display                   'simple
        treemacs-file-event-delay                2000
        treemacs-file-extension-regex            treemacs-last-period-regex-value
        treemacs-file-follow-delay               0.2
        treemacs-file-name-transformer           #'identity
        treemacs-follow-after-init               t
        treemacs-expand-after-init               t
        treemacs-find-workspace-method           'find-for-file-or-pick-first
        treemacs-git-command-pipe                ""
        treemacs-goto-tag-strategy               'refetch-index
        treemacs-header-scroll-indicators        '(nil . "^^^^^^")
        treemacs-hide-dot-git-directory          t
        treemacs-indentation                     2
        treemacs-indentation-string              " "
        treemacs-is-never-other-window           nil
        treemacs-max-git-entries                 5000
        treemacs-missing-project-action          'ask
        treemacs-move-files-by-mouse-dragging    t
        treemacs-move-forward-on-expand          nil
        treemacs-no-png-images                   nil
        treemacs-no-delete-other-windows         t
        treemacs-project-follow-cleanup          nil
        treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position                        'left
        treemacs-read-string-input               'from-child-frame
        treemacs-recenter-distance               0.1
        treemacs-recenter-after-file-follow      nil
        treemacs-recenter-after-tag-follow       nil
        treemacs-recenter-after-project-jump     'always
        treemacs-recenter-after-project-expand   'on-distance
        treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
        treemacs-project-follow-into-home        nil
        treemacs-show-cursor                     nil
        treemacs-show-hidden-files               t
        treemacs-silent-filewatch                nil
        treemacs-silent-refresh                  nil
        treemacs-sorting                         'alphabetic-asc
        treemacs-select-when-already-in-treemacs 'move-back
        treemacs-space-between-root-nodes        t
        treemacs-tag-follow-cleanup              t
        treemacs-tag-follow-delay                1.5
        treemacs-text-scale                      nil
        treemacs-user-mode-line-format           nil
        treemacs-user-header-line-format         nil
        treemacs-wide-toggle-width               70
        treemacs-width                           35
        treemacs-width-increment                 1
        treemacs-width-is-initially-locked       t
        treemacs-workspace-switch-cleanup        nil)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (pcase (cons (not (null (executable-find "git")))
               (not (null treemacs-python-executable)))
    (`(t . t)
     (treemacs-git-mode 'deferred))
    (`(t . _)
     (treemacs-git-mode 'simple)))
  (treemacs-hide-gitignored-files-mode nil))
;; Filepaths
(defvar my/journal-dir "~/org/journal" "Directory for my journals.")
(defvar my/roam-dir "~/org" "Directory for my org-roam notes")
(defvar my/bookmarks-file "~/org/bookmarks.org" "Bookmarks File")
(setq org-refile-targets
   '((("~/org/journal/todo-masterlist.org") :maxlevel . 2)
     (("~/org/workspace_archive.org") :maxlevel . 1)))
;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

(require 'org-tempo)

;;(use-package calfw
;;  :ensure t
;;  :demand t)
;;(use-package calfw-org
;;  :ensure t
;;  :demand t)

(use-package csv-mode
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))

;; basic adjustments
(global-visual-line-mode 1)
(repeat-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-laserwave  t))
(use-package doom-modeline
  :init (doom-modeline-mode 1))
(set-face-attribute 'default nil :height 170) 

;; ORG STUFF ;; 
;; org stuff
(add-to-list 'warning-suppress-types '(org-element org-element-parser))
(setq org-hide-emphasis-markers t)

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-span 10
      org-agenda-start-on-weekday nil
      org-agenda-start-day "-3d")

(setq org-agenda-files '("~/org/journal/todo-masterlist.org"))

;; to make sure that non-todo items with a scheduled are exported to the ics
(setq org-icalendar-use-scheduled '(event-if-not-todo todo-start))
(setq org-icalendar-scheduled-summary-prefix " ")
;; Org Todos to ical export
(setq org-icalendar-include-todo t)

;; ORG EXPORT STUFF ;; 
(setq org-export-creator-string "")     
(setq org-export-with-author nil)       
(setq org-export-with-tags nil)         
(setq org-export-with-toc nil)          
(setq org-export-with-todo-keywords nil)
(setq org-export-with-broken-links t)
(use-package org-appear
  :after org
  :custom (add-hook 'org-mode-hook 'org-appear-mode))

(setq org-structure-template-alist
   '(("a" . "aside") ("c" . "center") ("C" . "comment")
     ("e" . "src elisp :results none") ("h" . "src html")
     ("l" . "export latex") ("q" . "quote") ("s" . "src")
     ("v" . "verse") ("n" . "note") ("p" . "aside :noexport")))

(use-package org-modern)
(with-eval-after-load 'org (global-org-modern-mode))

(setq org-capture-templates
  '(("c" "college related stuff")
    ("cs" "scheduled college todo" entry
     (file+headline "~/org/journal/todo-masterlist.org" "College")
     "** TODO %? \n SCHEDULED: %^t")
    ("cd" "deadline college todo" entry
     (file+headline "~/org/journal/todo-masterlist.org" "College")
     "** TODO %? \n DEADLINE: %^t")
    ("ct" "general college todo" entry
     (file+headline "~/org/journal/todo-masterlist.org" "College")
     "** TODO %?")
    ("t" "General Todo" entry
     (file+headline "~/org/journal/todo-masterlist.org" "Unorganized")
     "** TODO %? %^g")
    ("e" "Event" entry
     (file+headline "~/org/journal/todo-masterlist.org" "Events")
     "** TODO %? %^g\n %^t")
  ("b" "bookmark" entry
   (file+headline "~/org/journal/bookmarks.org" "Inbox")
   "** %? %^g \n :PROPERTIES: \n :CREATED: %t \n:END:")
 ("w" "orgprotocol bookmark" entry
   (file+headline "~/org/journal/bookmarks.org" "Inbox")
   "** [[%:link][%:description]] %i %?\n:PROPERTIES:\n:CREATED: %t\n:END:")))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org"))
   (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head
               "${slug}.org"
               "#+title: ${title}\n#+created: %(format-time-string \"%Y-%m-%d\")\n#+filetags:\n#+lastmod:\n")
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))
  
(use-package org-roam-ui
  :ensure t                             
  :after org-roam)

(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir (expand-file-name my/journal-dir))
  (org-journal-file-type 'monthly)
  (org-journal-file-format "%Y-%m-%b.org")
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-carryover-items ""))

(setq org-journal-file-header
      (lambda (time)
        (concat
         ":PROPERTIES:\n"
         ":ID: " (format-time-string "month-%Y-%m" time) "\n"
         ":END:\n"
         "#+title: " (format-time-string "%B %Y" time) "\n"
         "#+startup: folded\n"
         "#+filetags: :private:\n"
         "#+lastmod:\n\n")))

;; My custom functions
(defun my/open-init-file ()
  "open the init file." (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory))) ;; find your init file
(global-set-key (kbd "C-c o i") #'my/open-init-file)

(defun open-org-roam-directory-in-dired ()
  "Open the org-roam-directory in Dired."
  (interactive)
  (let ((dir (or org-roam-directory default-directory)))
    (dired dir)))
(global-set-key (kbd "C-c o n") 'open-org-roam-directory-in-dired)

(defun my/open-todo-master ()
  "Open the master todo file from journal" (interactive)
  (find-file (expand-file-name "todo-masterlist.org" my/journal-dir)))

(defun my/org-update-lastmod ()
  "Update the last modified timestamp in the current buffer."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (let ((time-str (format-time-string "%Y-%m-%d %H:%M:%S")))
        (if (re-search-forward "^#\\+lastmod:.*$" nil t)
            (replace-match (concat "#+lastmod: " time-str) t t)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert "#+lastmod: " time-str "\n"))))))

;; keybindings
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c j") 'org-journal-new-entry)
(global-set-key (kbd "C-c o j") 'org-journal-open-current-journal-file)
(global-set-key (kbd "C-c l") 'org-goto-calendar)
(global-set-key (kbd "C-z") 'scratch-buffer)
(global-set-key (kbd "C-c o t") #'my/open-todo-master)
		
;; better face for displaying keybindings in org mode
(defface my/button-face
  '((t (:inherit icon-button :box (:line-width -1 :style released-button))))
  "Face that looks like a raised button.")

(defun my/org-fontify-hidden-buttons ()
  "Fontify [~ ... ~] blocks and hide outer markers."
  (font-lock-add-keywords
   nil
   '(("\\(\\[~\\)\\(.*?\\)\\(~\\]\\)"
      (1 '(face default invisible t))
      (2 'my/button-face)
      (3 '(face default invisible t))))))
(add-hook 'org-mode-hook #'my/org-fontify-hidden-buttons)

(use-package plantuml-mode
  :config
    (setq plantuml-default-exec-mode 'jar)
    (setq plantuml-jar-path "~/plantuml.jar")
    (setq org-plantuml-jar-path (expand-file-name "~/.emacs.d/plantuml.jar")))

(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t) (python . t)))

(use-package uniline
  :defer t)

(defun org-dblock-write:org-tags-count (params)
  "Create a table of tags and their counts for the current Org buffer."
  (let ((tag-counts (make-hash-table :test 'equal)))
    ;; Collect tag counts
    (org-map-entries
     (lambda ()
       (dolist (tag (org-get-tags))
         (puthash tag (1+ (gethash tag tag-counts 0)) tag-counts))))
    ;; Generate Org table
    (let ((tags (sort (hash-table-keys tag-counts)
                      (lambda (a b)
                        (> (gethash a tag-counts) (gethash b tag-counts))))))
      (insert "| Tag | Count |\n")
      (insert "|------|-------|\n")
      (dolist (tag tags)
        (insert (format "| %s | %d |\n" tag (gethash tag tag-counts)))))))

(defun my/update-org-tags-count-on-save ()
  "Update the :org-tags-count: dynamic block before saving the Org file."
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^#\\+BEGIN: org-tags-count" nil t)
        (org-update-dblock)))))
;; for the ability to add screenshots from clipboard 
;;(use-package org-download)
;;(setq org-download-image-dir "images")
(use-package org-web-tools
  :defer t)
(use-package org-transclusion
  :defer t)
(use-package popper
    :ensure t  
  :bind (("s-`"   . popper-toggle)
         ("s-<tab>"   . popper-cycle)
         ("s-M-`" . popper-toggle-type))
 :init
(setq popper-reference-buffers
      '("\\*Messages\\*"
        "Output\\*$"
        help-mode
        compilation-mode
        "Warning"
        "Backtrace"
        ))
(popper-mode +1))

(use-package org-roam-timeline
  :defer t)
(use-package wikinfo
  :defer t)
(use-package wikinforg
  :load-path "edited/"
  :defer t)

(require 'org-protocol)

(add-to-list
 'safe-local-variable-values
 '(eval progn
        (add-hook 'before-save-hook #'my/org-update-lastmod nil 'local)))

(add-to-list
 'safe-local-variable-values
 '(eval add-hook 'after-save-hook (lambda nil (org-icalendar-export-to-ics)) nil
           t))

;; (use-package citar
;;   :no-require
;;   :custom
;;   (org-cite-global-bibliography '("~/Documents/notes/references-meta/My Library.bib"))
;;   (org-cite-insert-processor 'citar)
;;   (org-cite-follow-processor 'citar)
;;   (org-cite-activate-processor 'citar)
;;   (citar-bibliography org-cite-global-bibliography)
;; (org-cite-export-processors
;;  '((md . (csl "~/Documents/notes/references-meta/apa.csl"))   ; Footnote reliant
;;    (odt . (csl "~/Documents/notes/references-meta/apa.csl"))  ; Footnote reliant
;;    ;(t . (csl "~/Documents/notes/references-meta/apa.csl"))
;;    ))      ; Fallback
;;   ;; optional: org-cite-insert is also bound to C-c C-x C-@
;;   :bind
;;   (:map org-mode-map :package org ("C-c b" . #'org-cite-insert)))

(defun my-org-confirm-babel-evaluate (lang body)
  (not (string= lang "plantuml")))  ;don't ask for plantuml 
(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)

(use-package org-mindmap
  :vc (:url "https://github.com/krvkir/org-mindmap.git" :rev :newest)
  :after org
  :config)

;; Android-specific toolbar
(use-package material-pbm-icons
  :ensure nil
  :load-path "~/.emacs.d/material-pbm-icons"
  :demand t)

(use-package tool-bar
  :ensure nil
  :defer t
  :init
  (defun kill-local-tool-bar-map ()
    (kill-local-variable 'tool-bar-map))
  :hook ((prog-mode text-mode special-mode compilation-mode) . kill-local-tool-bar-map)
  :custom
  (tool-bar-mode t)
  (tool-bar-position 'bottom)
  (tool-bar-button-margin 25)
  (modifier-bar-mode t)
  :config
  (defun android-support-kill-buffer (arg)
    (interactive "p")
    (cond
     ((>= arg 4) (kill-buffer-and-window))
     ((>= arg 1) (kill-buffer))))
  (defun android-support-save-buffer ()
    (interactive)
    (if (and (buffer-modified-p) (or (derived-mode-p 'prog-mode) (derived-mode-p 'text-mode)))
        (save-buffer)
      (save-some-buffers)))
  (defun android-support-toggle-touch-screen-keyboard ()
    (interactive)
    (message
     "Touch screen keyboard %s"
     (if (setf touch-screen-display-keyboard (not touch-screen-display-keyboard))
         "enabled" "disabled")))
  (defcustom android-support-global-tool-bar-custom-commands nil "Custom commands on the Android global tool bar.")
  (defmacro define-android-support-global-tool-bar-custom-commands (n)
    `(progn . ,(cl-with-gensyms (command)
                 (cl-loop for i from 1 to n
                          collect `(defun ,(intern (format "%s-%d" 'android-support-global-tool-bar-custom-command i)) ()
                                     (interactive)
                                     (when-let ((,command (nth ,(1- i) android-support-global-tool-bar-custom-commands)))
                                       (call-interactively ,command)))))))
  (define-android-support-global-tool-bar-custom-commands 6)
  (defconst android-support-global-tool-bar-items
    '(("close-outline" keyboard-quit)
      ("plus-circle-multiple-outline" universal-argument)
      ("file-replace-outline" consult-buffer switch-to-buffer)
      ("arrow-u-left-top" undo)
      ("arrow-up" previous-line)
      ("content-save-outline" android-support-save-buffer save-buffer)
      ("numeric-1-circle-outline" android-support-global-tool-bar-custom-command-1)
      ("numeric-2-circle-outline" android-support-global-tool-bar-custom-command-2)
      ("numeric-3-circle-outline" android-support-global-tool-bar-custom-command-3)
      ("menu" imenu)
      ("arrow-collapse-right" indent-for-tab-command)
      ("circle-multiple-outline" execute-extended-command)
      ("close-circle-multiple-outline" exchange-point-and-mark)
      ("arrow-left" backward-char)
      ("arrow-down" next-line)
      ("arrow-right" forward-char)
      ("numeric-4-circle-outline" android-support-global-tool-bar-custom-command-4)
      ("numeric-5-circle-outline" android-support-global-tool-bar-custom-command-5)
      ("numeric-6-circle-outline" android-support-global-tool-bar-custom-command-6)
      ("magnify" isearch-forward)))
  (defun android-support-global-tool-bar-setup ()
    (setf tool-bar-map '(keymap nil))
    (cl-loop for (icon command key) in android-support-global-tool-bar-items
             do (tool-bar-add-item icon command (or key command))))
  (android-support-global-tool-bar-setup)
  (define-key key-translation-map (kbd "<tool-bar> <keyboard-quit>") (kbd "C-g"))
  (define-key key-translation-map (kbd "<tool-bar> <execute-extended-command>") (kbd "C-c"))
  (define-key key-translation-map (kbd "<tool-bar> <exchange-point-and-mark>") (kbd "C-x"))
  (define-key key-translation-map (kbd "<tool-bar> <imenu>") (kbd "M-g"))
  (define-key key-translation-map (kbd "<tool-bar> <isearch-forward>") (kbd "M-s"))
  (global-set-key (kbd "C-x <up>") #'delete-other-windows)
  (global-set-key (kbd "C-x <down>") #'split-window-below)
  (global-set-key (kbd "C-c <tool-bar> <universal-argument>") #'execute-extended-command)
  (global-set-key (kbd "C-x <tool-bar> <universal-argument>") #'er/expand-region)
  (global-set-key (kbd "C-c <tool-bar> <undo>") #'pop-to-mark-command)
  (global-set-key (kbd "C-x <tool-bar> <undo>") #'quit-window)
  (global-set-key (kbd "C-c <tool-bar> <switch-to-buffer>") #'project-find-file)
  (global-set-key (kbd "C-x <tool-bar> <switch-to-buffer>") #'find-file)
  (global-set-key (kbd "C-c <tool-bar> <save-buffer>") #'bookmark-set)
  (global-set-key (kbd "C-x <tool-bar> <save-buffer>") #'android-support-kill-buffer)
  (global-set-key (kbd "M-s M-s") #'isearch-forward)
  (global-set-key (kbd "M-g M-s") #'consult-imenu)
  (global-set-key (kbd "M-s M-g") (if (executable-find "rg") #'consult-ripgrep #'consult-grep))
  (global-set-key (kbd "C-x M-g") #'android-support-toggle-touch-screen-keyboard)
  (global-set-key (kbd "C-x M-s") #'read-only-mode)
  (define-key key-translation-map (kbd "<tool-bar> <indent-for-tab-command>") (kbd "TAB"))
  (define-key key-translation-map (kbd "<tool-bar> <previous-line>") (kbd "<up>"))
  (define-key key-translation-map (kbd "<tool-bar> <next-line>") (kbd "<down>"))
  (define-key key-translation-map (kbd "<tool-bar> <backward-char>") (kbd "<left>"))
  (define-key key-translation-map (kbd "<tool-bar> <forward-char>") (kbd "<right>")))

(provide 'android-support)
;;; android-support.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(safe-local-variable-values
   '((eval setq org-hugo-auto-export-mode nil)
     (eval add-hook 'after-save-hook
	   (lambda nil (org-icalendar-export-to-ics)) nil t)
     (eval progn
	   (add-hook 'before-save-hook #'my/org-update-lastmod nil
		     'local)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
