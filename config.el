;;; private/cole/config.el -*- lexical-binding: t; -*-

(load! "+bindings")

(load! "notmuch")

(load! "org")

(setq user-full-name "Cole Lyman"
      user-mail-address "cole@colelyman.com")

(defvar killed-file-list nil
  "List of recently killed files.")

(add-hook! 'kill-buffer-hook 'add-file-to-killed-file-list)
