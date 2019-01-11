;;; ~/.config/doom/lint-prose.el -*- lexical-binding: t; -*-

(after! flycheck
  (flycheck-define-checker proselint
    "A linter for prose."
    :command ("proselint" source-inplace)
    :error-patterns
    ((warning line-start (file-name) ":" line ":" column ": "
              (id (one-or-more (not (any " "))))
              (message) line-end))
    :modes (text-mode markdown-mode org-mode))

  (add-to-list 'flycheck-checkers 'proselint))

(def-package! flycheck-vale
 :config
 (flycheck-vale-setup)
 (setq flycheck-vale-toggle-enabled t))

;; (use-package flycheck-vale)
