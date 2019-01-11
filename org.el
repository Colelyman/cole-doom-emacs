;;; ~/.config/doom/org.el -*- lexical-binding: t; -*-

;; General org settings
(after! org
  (setq org-todo-keywords '((sequence "TODO" "WAIT" "DONE"))
        org-log-done 'time
        org-clock-report-include-clocking-task t
        org-directory (expand-file-name "~/org")
        org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-pdf-process
        '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f")
        +org-export-dir default-directory
        org-file-apps '(("pdf" . emacs)
                        ("\\.x?html?\\'" . emacs)
                        ("/docs/" . emacs)
                        (auto-mode . emacs)
                        (directory . emacs)
                        (t . "open -R \"%s\""))
        org-agenda-files (list "~/org/master.org" "~/org/2018/fall.org")
        (nthcdr 4 org-emphasis-regexp-components) 10
        org-capture-templates
        '(("e" "Email task" entry (file+olp+datetree "~/org/master.org")
           "* TODO %? :EMAIL:\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
          ("t" "Todo" entry (file+olp+datetree "~/org/master.org")
           "* TODO %?\nDEADLINE: %^t")
          ("s" "School todo" entry (file "~/org/2018/spring.org")
           "* TODO %? %^g\nDEADLINE: %^t")
          ("j" "Journal entry" plain (file+olp+datetree "~/org/journal.org")
           "%?")
          ("z" "Zettel" entry (file+olp ozk-zettelkasten-file "Zettels")
           "* %(ozk-get-header) %^{Title} %^g\n:properties:\n  :id: %(ozk-get-header)\n:end:\n%?")
          ("h" "Hugo post" entry (file+olp "~/code/colelyman-hugo/site/content-org/posts.org" "Blog Ideas")
           (function org-hugo-new-subtree-post-capture-template))))
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  (advice-remove #'org-export-output-file-name #'+org*export-output-file-name))

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
        org-ref-default-bibliography (list (concat org-ref-directory "index.bib"))
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
  :commands interleave-mode)

(map! (:after org
        (:map org-mode-map
          :localleader
          :desc "Edit SRC block" :nvm "'" #'org-edit-src-code
          :desc "Toggle interleave mode" :nvm "i" #'interleave-mode)))

(autoload 'org-invoice-report "org-invoice")
(autoload 'org-dblock-write:invoice "org-invoice")

(defun generate-invoice ()
  (interactive)
  (defun get-invoice-num ()
    (save-excursion
      (beginning-of-buffer)
      (re-search-forward "\\* Invoices" nil t)
      (org-end-of-subtree)
      (outline-up-heading 1 t)
      (re-search-forward "Invoice " nil t)
      (let* ((begin-invoice-num-point (point))
             (invoice-num 1))
        (forward-word)
        (setq invoice-num (string-to-number
                           (buffer-substring begin-invoice-num-point (point))))
        ;; (goto-char (pop-mark))
        invoice-num)))
  (message "Invoice number: %d" (1+ (get-invoice-num)))
  (let* ((invoice-num (1+ (get-invoice-num)))
        (now (current-time))
        (two-weeks (time-add now (* 14 24 3600)))
        (time-format "[%Y-%m-%d %a]"))
    (save-excursion
      (re-search-forward "\\* Invoices" nil t)
      (org-end-of-subtree)
      (insert (format "\n** Invoice %d %s--%s"
                      invoice-num
                      (format-time-string time-format now)
                      (format-time-string time-format two-weeks))))))
