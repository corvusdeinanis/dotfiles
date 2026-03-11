;;; init.el --- -*- lexical-binding: t -*-

;; Prevent Emacs from writing to init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

;; ---------------------------------------------------------------------
;; Package setup
;; ---------------------------------------------------------------------
(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(setq package-archive-priorities
      '(("gnu" . 50) ("nongnu" . 25) ("melpa-stable" . 10) ("melpa" . 0)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; BASIC EMACS STUFF
(savehist-mode 1)

(setq backup-directory-alist
      `(("." . ,(expand-file-name ".backup" (or user-emacs-directory "~/.emacs.d/"))))
      version-control t
      kept-new-versions 10
      kept-old-versions 0
      delete-old-versions t
      backup-by-copying t
      confirm-kill-processes nil
      create-lockfiles nil
      use-dialog-box nil)

(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-visual-line-mode 1)
(repeat-mode 1)
(load-theme 'doom-rouge t)
;; BASIC ORG STUFF
(add-to-list 'warning-suppress-types '(org-element org-element-parser))
;; to suppress warnings about org-element-at-point when
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-hide-emphasis-markers t)

;;  PACKAGES
(use-package vertico
  :init (vertico-mode 1)
  :config
  (setq vertico-count 6)  
  :ensure t)

(use-package marginalia
  :init (marginalia-mode 1)
  :ensure t)

(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))
(use-package orderless
       :ensure t
       :custom
       (completion-styles '(orderless basic))
       (completion-category-overrides '((file (styles basic partial-completion))))
       (orderless-matching-styles
	'(orderless-literal
	  orderless-prefixes
	  orderless-initialism
	  orderless-regexp
	  ;; orderless-flex
	  )))      
(use-package prescient
  :ensure t)

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-span 10
      org-agenda-start-on-weekday nil
      org-agenda-start-day "-3d")


(use-package wikinforg
  :ensure t
  :defer t)

(defvar my/journal-dir "~/Documents/journal" "Directory for my journals.")
(defvar my/roam-dir "~/Documents/notes" "Directory for my org-roam notes")
(defvar my/bookmarks-file "~/Documents/journal/bookmarks.org" "Bookmarks File")

(use-package org-roam
;  :after org - this leads to this block not being evaluated so I commented it. 
  :pin melpa
  :custom
  (org-roam-directory (expand-file-name "~/Documents/notes"))
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head
               "${slug}.org"
               "#+title: ${title}\n#+created: %(format-time-string \"%Y-%m-%d\")\n#+filetags:\n#+lastmod:\n")
      :unnarrowed t)))
  :config
  (org-roam-db-autosync-mode)
  ;; moved inside the :config so it runs at the right time
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag))))

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

;; ----- CUSTOM FUNCTIONS ----- ;;
;; dynamic block that counts tags in org-journal
(defun org-dblock-write:org-tags-count (_params)
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

(add-hook 'before-save-hook #'my/update-org-tags-count-on-save)

;; Archive Done Tasks   - TODO preserve the heading level -- moved to archived-init-functions.el

;; Count days between an org-timestamp and now - Non-interactive
(defun days-since-org-timestamp (org-timestamp)
  "Calculate the number of days elapsed since the given ORG-TIMESTAMP.
ORG-TIMESTAMP should be a string in the format '[YYYY-MM-DD]'." 
  (let* ((parsed-time (org-time-string-to-time org-timestamp))
         (current-time (current-time))
         (elapsed-seconds (float-time (time-subtract current-time parsed-time)))
         (elapsed-days (/ elapsed-seconds 86400))) ; 86400 seconds in a day
    (message "Days elapsed since %s: %d" org-timestamp (floor elapsed-days))))

;; plantuml-mode moved to archived-functions.el
;; mermaid-cli moved to archived-functions.el 
(use-package consult
  :ensure t)
(use-package helm
  :ensure t)
(use-package company)

(defun my/open-init-file ()
  "open the init file." (interactive)
  (find-file user-init-file)) ;; find your init file
(global-set-key (kbd "C-c o i") #'my/open-init-file)

; hugo stuff moved to archived-init-functions.el 
(require 'org-tempo) ; needed for quickly inserting structure templates https://orgmode.org/manual/Structure-Templates.html

(use-package ox-hugo ; code snippet from https://ox-hugo.scripter.co/doc/installation/
  :ensure t
  :pin melpa  
  :after ox)

(defun my/open-todo-master ()
  "Open the master todo file from journal" (interactive)
  (find-file (expand-file-name "todo-masterlist.org" my/journal-dir)))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c j") 'org-journal-new-entry)
(global-set-key (kbd "C-c o j") 'org-journal-open-current-journal-file)
(global-set-key (kbd "C-c l") 'org-goto-calendar)
(global-set-key (kbd "C-c n") 'org-roam-node-find)
(global-set-key (kbd "C-z") 'scratch-buffer)
(global-set-key (kbd "C-c i n") 'org-roam-node-insert) 
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

;; better face for keybindings!
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

(use-package org-transclusion
  :after org
  :config
  (setq org-transclusion-include-first-section nil)
  :ensure t)

(use-package ztree)

(use-package consult-notes
  :after consult
  :config
  (setq consult-notes-file-dir-sources
      '(("Org-Journal"             ?j "~/Documents/journal/")
        ("Org-Roam"      ?r "~/Documents/notes/"))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))


(setq org-agenda-custom-commands
      '(("c" "College Agenda"
         ((agenda "")
          (alltodo ""))
         ((org-agenda-overriding-header "College Tasks")
          (org-agenda-skip-function
           '(org-agenda-skip-entry-if 'notregexp ":college:"))))))

(setq org-refile-targets
      '((("~/Documents/notes/college-overview.org") :maxlevel . 2)
	(("~/Documents/journal/personal-todos.org") :maxlevel . 2)
	(("~/Documents/notes/workspace_archive.org") :maxlevel . 1)
	))

(use-package age
  :ensure t
  :demand t
  :config
  ;(age-file-enable)
  )

(require 'org-protocol)
(setq org-capture-templates
    (quote (
        ("w" "web site" entry (file+headline my/bookmarks-file "Inbox")
         "* [[%:link][%:description]] :@web:\n\n %i" :immediate-finish t))))

(use-package org-modern)
(with-eval-after-load 'org (global-org-modern-mode))
