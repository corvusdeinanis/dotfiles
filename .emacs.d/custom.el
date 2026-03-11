(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-sources
   '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"
     "~/.emacs.d/secrets/.authinfo"))
 '(calendar-holidays
   '((holiday-fixed 1 1 "New Year's Day")
     (holiday-fixed 10 31 "Halloween")
     (holiday-float 11 4 4 "Thanksgiving") (holiday-easter-etc)
     (holiday-fixed 12 25 "Christmas")))
 '(citar-bibliography '("~/Documents/notes/references-meta/My Library.bib"))
 '(custom-safe-themes
   '("02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644"
     "545ab1a535c913c9214fe5b883046f02982c508815612234140240c129682a68"
     default))
 '(denote-directory "/home/astro/Documents/journal/notes")
 '(holiday-general-holidays
   '((holiday-fixed 1 1 "New Year's Day")
     (holiday-float 5 0 2 "Mother's Day")
     (holiday-fixed 10 31 "Halloween")
     (holiday-float 11 4 4 "Thanksgiving")))
 '(org-agenda-files
   '("~/Documents/github/astroslair--groundup/readme.org"
     "/home/astro/Documents/journal/todo-masterlist.org"
     "/home/astro/Documents/notes/college-overview.org"
     "/home/astro/Documents/journal/events.org"))
 '(org-caldav-calendar-id "emacs")
 '(org-caldav-exclude-tags '(":noexport:"))
 '(org-caldav-files '("~/Documents/notes/college-overview.org"))
 '(org-caldav-inbox "/home/astro/Documents/cal-inbox.org")
 '(org-caldav-sync-direction 'org->cal)
 '(org-caldav-sync-todo t)
 '(org-caldav-url
   "https://wim.nl.tab.digital/remote.php/dav/calendars/astrob")
 '(org-cite-csl-styles-dir "~/Documents/notes/references-meta/")
 '(org-cite-global-bibliography '("~/Documents/notes/references-meta/My Library.bib"))
 '(org-directory "~/Documents/journal")
 '(org-export-creator-string "")
 '(org-export-with-section-numbers nil)
 '(org-export-with-toc nil)
 '(org-html-creator-string "")
 '(org-html-postamble nil)
 '(org-html-validation-link "")
 '(org-hugo-allow-spaces-in-tags nil)
 '(org-hugo-export-creator-string "")
 '(org-hugo-export-with-toc 2)
 '(org-hugo-front-matter-format "yaml")
 '(org-hugo-section "entries")
 '(org-plantuml-exec-mode 'plantuml)
 '(org-structure-template-alist
   '(("a" . "aside") ("c" . "center") ("C" . "comment")
     ("e" . "src elisp :results none") ("h" . "src html")
     ("l" . "export latex") ("q" . "quote") ("s" . "src")
     ("v" . "verse") ("n" . "note") ("p" . "aside :noexport")))
 '(org-tag-faces '(("@web" . "#ff39a3")))
 '(package-selected-packages
   '(age anzu bug-hunter calfw calfw-org chronos citar company
	 consult-flyspell consult-notes csv-mode dashboard deferred
	 denote dired-sidebar doom-modeline doom-themes esup fsrs
	 gnuplot helm-org-ql hyperbole magit marginalia markdown-mode
	 metrics-tracker nano-agenda nice-org-html nov olivetti
	 orderless org-appear org-attach-screenshot org-contrib
	 org-journal org-journal-tags org-modern org-ql
	 org-rainbow-tags org-roam-ql org-roam-timeline org-roam-ui
	 org-sidebar org-transclusion org-web-tools org-window-habit
	 ox-hugo plantuml-mode popper prescient request spell-fu
	 svg-tag-mode uniline vdiff vertico visual-regexp-steroids w3m
	 wikinforg yaml-mode ztree))
 '(plantuml-jar-path "/home/astro/.emacs.d/plantuml.jar")
 '(safe-local-variable-values
   '((eval progn (org-hugo-base-dir . "~/Documents/org-quartz/")
	   (add-hook 'before-save-hook #'my/org-update-lastmod nil
		     'local))
     (eval progn
	   (add-hook 'before-save-hook #'my/org-update-lastmod nil
		     'local))
     (org-hugo-front-matter-format "yaml")
     (eval setq-local org-fold-core-style 'overlays)
     (eval progn (org-hugo-auto-export-mode)
	   (add-hook 'before-save-hook #'my/org-update-lastmod nil
		     'local))
     (org-src-preserve-indentation) (org-hide-macro-markers . t)
     (eval add-hook 'before-save-hook #'my/org-update-lastmod nil
	   'local)))
 '(savehist-file "~/.emacs.d/history")
 '(uniline-show-welcome-message nil)
 '(use-package-enable-imenu-support t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(secondary-selection ((t (:extend t :background "gray25" :foreground "white")))))
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
