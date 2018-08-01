;;; ~/.config/doom/org.el -*- lexical-binding: t; -*-

;; General org settings
(after! org
  (setq org-todo-keywords '((sequence "TODO" "WAIT" "DONE"))
        org-log-done 'time
        org-directory (expand-file-name "~/org")
        org-agenda-files (list "~/org/master.org" "~/org/2018/fall.org")
        org-capture-templates
        '(("e" "Email task" entry (file+olp+datetree "~/org/master.org")
           "* TODO %? :EMAIL:\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
          ("t" "Todo" entry (file+olp+datetree "~/org/master.org")
           "* TODO %?\nDEADLINE: %^t")
          ("s" "School todo" entry (file "~/org/2018/spring.org")
           "* TODO %? %^g\nDEADLINE: %^t")
          ("h" "Hugo post" entry (file+olp "~/code/colelyman-hugo/site/content-org/posts.org" "Blog Ideas")
           (function org-hugo-new-subtree-post-capture-template))))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  (advice-add 'org-refile :after 'org-save-all-org-buffers))

;; org-ref settings
(def-package! org-ref
  :defer t
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (setq org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :INTERLEAVE_PDF: ./lib/%k.pdf\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
        org-ref-directory (concat (file-name-as-directory org-directory) "papers/")
        org-ref-notes-directory org-ref-directory
        org-ref-bibliography-notes (concat org-ref-directory "index.org")
        org-ref-default-bibliography '((concat org-ref-directory "index.bib"))
        org-ref-pdf-directory (concat org-ref-directory
                                      (file-name-as-directory "lib"))
        bibtex-completion-bibliography (concat org-ref-directory "index.bib")
        bibtex-completion-library-path org-ref-pdf-directory
        bibtex-completion-notes-path org-ref-bibliography-notes))

;; ox-hugo settings
(def-package! ox-hugo
  :defer t
  :after ox
  :config
  (add-hook! org-capture-before-finalize #'+cole/org-capture--remove-auto-org-to-hugo-export-maybe)
  (add-hook! org-capture-after-finalize #'+cole/org-capture--add-auto-org-to-hugo-export-maybe))

(def-package! interleave
  :defer t)

(map! (:after org
        (:map org-mode-map
          :localleader
          :desc "Edit SRC block" :nvm "'" #'org-edit-src-code
          :desc "Toggle interleave mode" :nvm "i" #'interleave-mode)))
