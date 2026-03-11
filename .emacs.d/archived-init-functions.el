(setq org-capture-templates
      '(("j" "Journal Entry"
         plain
         (function (lambda () (org-journal-new-entry t)))
         "** %(format-time-string \"%H:%M\")\n%?"
         :unnarrowed t)
        ("f" "Food Entry"
         plain
         (function (lambda () (org-journal-new-entry t)))
         "** %(format-time-string \"%H:%M\")\nFood: %?"
         :unnarrowed t)))
