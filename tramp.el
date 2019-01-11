;;; ~/.config/doom/tramp.el -*- lexical-binding: t; -*-

(after! tramp-mode
  (setq vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp)
        tramp-completion-reread-directory-timeout nil
        tramp-verbose 1
        remote-file-name-inhibit-cache nil))
