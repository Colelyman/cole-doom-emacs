;;; ~/.config/doom/org.el -*- lexical-binding: t; -*-

(after! org
  (setq org-todo-keywords '((sequence "TODO" "WAIT" "DONE"))
        org-directory (expand-file-name "~/org")
        org-agenda-files (list "~/org/master.org" "~/org/2018/fall.org")
        org-capture-templates
        '(("e" "Email task" entry (file+olp+datetree "~/org/master.org")
           "* TODO %? :EMAIL:\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
          ("t" "Todo" entry (file+olp+datetree "~/org/master.org")
           "* TODO %?\nDEADLINE: %^t")
          ("s" "School todo" entry (file "~/org/2018/spring.org")
           "* TODO %? %^g\nDEADLINE: %^t")))
  (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  (advice-add 'org-refile :after 'org-save-all-org-buffers))
