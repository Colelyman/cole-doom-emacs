;;; ~/.config/doom/code.el -*- lexical-binding: t; -*-

;; Common Lisp set up
(setq inferior-lisp-program "sbcl")

;; if compilation is successful, then close the buffer after 1 second
;; from: https://emacs.stackexchange.com/questions/62/hide-compilation-window
(setq compilation-finish-functions
      '((lambda (buf str)
          (if (null (string-match ".*exited abnormally.*" str))
              ;;no errors, make the compilation window go away in a few seconds
              (progn
                (run-at-time
                 "1 sec" nil 'delete-windows-on
                 (get-buffer-create "*compilation*"))
                (message "No Compilation Errors!"))))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(def-package! emamux
  :defer t
  :config
  (setq emamux:completing-read-type 'ido)
  (global-set-key (kbd "C-b") emamux:keymap))

(setq racer-rust-src-path
      (concat (string-trim
               (shell-command-to-string "~/.cargo/bin/rustc --print sysroot"))
              "/lib/rustlib/src/rust/src"))

(setq flycheck-clang-include-path '("../includes" "../inc")
      flycheck-gcc-include-path flycheck-clang-include-path)

(load! "~/code/gendoxy/gendoxy.el")
(setq gendoxy-backslash nil
      gendoxy-default-text ""
      gendoxy-skip-details nil
      gendoxy-details-empty-line t)
