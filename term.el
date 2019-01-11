;;; ~/.config/doom/term.el -*- lexical-binding: t; -*-

;; (map! :map term-mode-map
;;  :nvm "b" #'term-send-backward-word
;;  :nvm "e" #'term-send-forward-word
;;  :nvm "$" #'term-send-end
;;  :nvm "0" #'term-send-home)

(add-to-list 'load-path "~/Downloads/emacs-libvterm")

;; (def-package! vterm
;;   :defer t
;;   :commands (vterm
;;              vterm-other-window))

(let (vterm-install)
  (require 'vterm)
  (set-env! "SHELL")
  (add-hook 'vterm-mode-hook #'doom|mark-buffer-as-real)
  ;; (set-evil-initial-state! 'vterm-mode 'normal)
  (add-to-list 'evil-emacs-state-modes 'vterm-mode))
  (map! (:after vterm
          (:map vterm-mode-map
            :e "M-p" #'(lambda () (interactive) (vterm-send-key "<up>"))
            :e "M-n" #'(lambda () (interactive) (vterm-send-key "<down>"))
            :e "M-r" #'vterm-send-ctrl-r)))
