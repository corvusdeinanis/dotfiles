;;; post-init.el --- loads AFTER init.el -*- no-byte-compile: t; lexical-binding: t; -*-
;; Keep compile-angel at the top!
(eval-when-compile (require 'use-package))
(use-package compile-angel
  :demand t
  :config
  ;; The following disables compilation of packages during installation;
  ;; compile-angel will handle it.
  (setq package-native-compile nil)
  
  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (push "/init.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/post-init.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (compile-angel-on-load-mode 1))
;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
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

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
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
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))
;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))
;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)
;; Corfu enhances in-buffer completion by displaying a compact popup with
;; current candidates, positioned either below or above the point. Candidates
;; can be selected by navigating up or down.
(use-package corfu
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  ;; Enable Corfu
  :config
  (global-corfu-mode))

(use-package cape
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; Vertico provides a vertical completion interface, making it easier to
;; navigate and select from completion candidates (e.g., when `M-x` is pressed).
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
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

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

  ;; The default width and height of the icons is 22 pixels. If you are
  ;; using a Hi-DPI display, uncomment this to double the icon size.
  ;; (treemacs-resize-icons 44)

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
(defvar my/journal-dir "~/Documents/journal" "Directory for my journals.")
(defvar my/roam-dir "~/Documents/notes" "Directory for my org-roam notes")
(defvar my/bookmarks-file "~/Documents/journal/bookmarks.org" "Bookmarks File")

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))
(require 'org-tempo)

(use-package calfw
  :ensure t
  :demand t)
(use-package calfw-org
  :ensure t
  :demand t)

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
  (load-theme 'doom-rouge  t))
(use-package doom-modeline
  :init (doom-modeline-mode 1))
 ;; ORG STUFF ;;
;; org stuff
(add-to-list 'warning-suppress-types '(org-element org-element-parser))
(setq org-hide-emphasis-markers t)

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-span 10
      org-agenda-start-on-weekday nil
      org-agenda-start-day "-3d")

(setq org-agenda-files '("~/Documents/journal/todo-masterlist.org"))

(setq org-refile-targets
   '((("~/Documents/journal/todo-masterlist.org") :maxlevel . 2)
     (("~/Documents/notes/workspace_archive.org") :maxlevel . 1)))

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

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/notes"))
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
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
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
  (org-journal-date-format "%A, %d %B %Y"))

(use-package ox-hugo ; code snippet from https://ox-hugo.scripter.co/doc/installation/
  :ensure t
  :pin melpa  
  :after ox)
;; My custom functions

(defun my/open-init-file ()
  "open the init file." (interactive)
  (find-file (expand-file-name "post-init.el" user-emacs-directory))) ;; find your init file
(global-set-key (kbd "C-c o i") #'my/open-init-file)

(defun my/open-todo-master ()
  "Open the master todo file from journal" (interactive)
  (find-file (expand-file-name "todo-masterlist.org" my/journal-dir)))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c j") 'org-journal-new-entry)
(global-set-key (kbd "C-c o j") 'org-journal-open-current-journal-file)
(global-set-key (kbd "C-c l") 'org-goto-calendar)
(global-set-key (kbd "C-z") 'scratch-buffer)
(global-set-key (kbd "C-c o t") #'my/open-todo-master)
		
(defun my/org-update-lastmod ()
  "Update the last modified timestamp in the current buffer."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (let ((time-str (format-time-string "%Y-%m-%d %H:%M:%S")))
        (if (re-search-forward "^#\\+lastmod:" nil t)
            (progn
              (kill-line)
              (insert " " time-str))
          (progn
            (goto-char (point-max))
            (insert "\n#+lastmod: " time-str)))))))

(add-hook 'before-save-hook #'my/org-update-lastmod)

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

(use-package uniline)

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
;; Org Todos to ical export
(setq org-icalendar-include-todo t)
;; for the ability to add screenshots from clipboard 
(use-package org-download)
(use-package org-web-tools)
(use-package org-transclusion)
(use-package popper
    :ensure t ; or :straight t
  :bind (("s-`"   . popper-toggle)
         ("s-<tab>"   . popper-cycle)
         ("s-M-`" . popper-toggle-type)))

(setq popper-reference-buffers
      '("\\*Messages\\*"
        "Output\\*$"
        help-mode
        compilation-mode
               ))
