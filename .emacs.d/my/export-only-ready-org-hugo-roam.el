;;;; --- Export only “ready”, strip it, and route to the right section ---

(require 'seq)
(defun my/org-filetags-list ()
  "Return file-wide tags from #+FILETAGS: as a list of strings.
Handles both colon style (:a:b:) and space-separated style."
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search t))
      (when (re-search-forward "^#\\+FILETAGS:\\s-*\\(.*\\)$" nil t)
        (let* ((raw (string-trim (match-string 1))))
          (if (string-match-p ":" raw)
              (seq-filter (lambda (s) (not (string-empty-p s)))
                          (split-string raw ":" t))   ; :a:b: -> ("a" "b")
            (split-string raw "[ \t]+" t)))))))        ; a b  -> ("a" "b")

(defun my/org--remove-ready-from-filetags-line ()
  "In the current buffer, rewrite #+FILETAGS: without `ready`."
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search t))
      (when (re-search-forward "^#\\+FILETAGS:\\s-*\\(.*\\)$" nil t)
        (let* ((tags (my/org-filetags-list))
               (filtered (seq-difference tags '("ready") #'string-equal))
               ;; normalize to space-separated; both forms are valid for Org/ox-hugo
               (newline (concat "#+FILETAGS: " (mapconcat #'identity filtered " "))))
          (replace-match newline t t))))))

(defun my/org--blog-section-p (tags)
  "Return non-nil if TAGS indicate the article should go in the blog section."
  (seq-intersection tags '("thoughts" "essay" "blog")))

(defun my/org--preexport-filter-remove-ready (backend)
  "Hook for `org-export-before-parsing-hook`.
Only runs for ox-hugo; removes `ready` from FILETAGS line in the temp buffer."
  (when (org-export-derived-backend-p backend 'md) ; ox-hugo derives from md/html
    (my/org--remove-ready-from-filetags-line)))

(defun my/org-hugo-export-ready-file (&optional arg)
  "Export this file with ox-hugo only if FILETAGS contain `ready`.
Also sets the Hugo section based on tags and strips `ready` in the output."
  (interactive "P")
  (let* ((tags (or (my/org-filetags-list) '()))
         ;; Decide section now; bind it for this export only.
         (org-hugo-section (if (my/org--blog-section-p tags) "blog" "posts")))
    (if (member "ready" tags)
        (progn
          ;; Buffer-local pre-export hook to strip `ready` from FILETAGS
          (add-hook 'org-export-before-parsing-hook
                    #'my/org--preexport-filter-remove-ready
                    0 t)
          (unwind-protect
              (org-hugo-export-wim-to-md arg)
            (remove-hook 'org-export-before-parsing-hook
                         #'my/org--preexport-filter-remove-ready t)))
      (message "ox-hugo: Skipping export — file is not tagged :ready:"))))

(defun my/org-hugo-export-all-ready ()
  "Export every Org file in `org-roam-directory` that has FILETAGS :ready:.
Respects section routing and strips `ready` on export."
  (interactive)
  (dolist (file (directory-files-recursively org-roam-directory "\\.org$"))
    (with-current-buffer (find-file-noselect file)
      (let ((tags (or (my/org-filetags-list) '())))
        (when (member "ready" tags)
          (let ((org-hugo-section (if (my/org--blog-section-p tags) "blog" "posts")))
            (add-hook 'org-export-before-parsing-hook
                      #'my/org--preexport-filter-remove-ready
                      0 t)
            (unwind-protect
                (progn
                  (message "ox-hugo: Exporting %s → section %s" file org-hugo-section)
                  (org-hugo-export-wim-to-md))
              (remove-hook 'org-export-before-parsing-hook
                           #'my/org--preexport-filter-remove-ready t))))))))
