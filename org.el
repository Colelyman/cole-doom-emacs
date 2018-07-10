;;; ~/.config/doom/org.el -*- lexical-binding: t; -*-

;; General org settings
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

;; org-ref settings
(def-package! org-ref
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (setq org-ref-directory (concat (file-name-as-directory org-directory) "papers")
        org-ref-notes-directory org-ref-directory
        org-ref-bibliography-notes (concat org-ref-directory
                                           (file-name-as-directory "index.org"))
        org-ref-default-bibliography '((concat org-ref-directory
                                               (file-name-as-directory "index.bib")))
        org-ref-pdf-directory (concat org-ref-directory
                                      (file-name-as-directory "lib"))
        bibtex-completion-bibliography (concat org-ref-directory
                                               (file-name-as-directory "index.bib"))
        bibtex-completion-library-path org-ref-pdf-directory
        bibtex-completion-notes-path org-ref-bibliography-notes))
