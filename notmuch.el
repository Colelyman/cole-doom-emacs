;;; private/cole/notmuch.el -*- lexical-binding: t; -*-

(load! "gnus-alias")
(def-package! gnus-alias
  :defer t
  :config
  (setq gnus-alias-identity-alist '(("zoho"
                                     nil
                                     "Cole Lyman <cole@colelyman.com>"
                                     nil
                                     nil
                                     nil
                                     nil)
                                    ("gmail"
                                     nil
                                     "Cole Lyman <coleandrewlyman@gmail.com>"
                                     nil
                                     nil
                                     nil
                                     nil))
        gnus-alias-default-identity "zoho")
  (gnus-alias-init))

(def-package! notmuch
  :defer t
  :commands (notmuch
             notmuch-tree
             notmuch-tree-mode
             notmuch-search
             notmuch-search-mode
             notmuch-hello
             notmuch-hello-mode
             notmuch-show
             notmuch-show-mode
             notmuch-message-mode)
  :config
  (setq notmuch-search-oldest-first nil
        notmuch-saved-searches '((:name "inbox" :key "i"
                                        :query "tag:inbox and (folder:Zoho/INBOX or folder:Zoho/Notification or folder:Zoho/Newsletter or folder:Gmail/INBOX or folder:Gmail/[Gmail].Important)")
                                 (:name "unread" :key "u"
                                        :query "tag:unread and not tag:spam and not tag:deleted")
                                 (:name "gmail" :key "g"
                                        :query "to:coleandrewlyman@gmail.com and not tag:spam and not tag:deleted"))
        mail-specify-envelope-from 'header
        mail-sendmail-envelope-from 'header
        message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program "/usr/local/bin/msmtp"
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-sendmail-f-is-evil t
        message-kill-buffer-on-exit t
        notmuch-show-all-multipart/alternative-parts t
        mail-user-agent 'message-user-agent)
  (set-evil-initial-state! 'notmuch-hello-mode 'normal)
  (set-evil-initial-state! 'notmuch-show-mode 'normal)
  (set-evil-initial-state! 'notmuch-search-mode 'normal)
  (set-evil-initial-state! 'notmuch-tree-mode 'normal)
  (set-evil-initial-state! 'notmuch-message-mode 'normal)
  (add-hook 'notmuch-tree-mode-hook #'+mail/buffer-face-mode-notmuch)
  (add-hook 'notmuch-search-hook #'+mail/buffer-face-mode-notmuch)
  (add-hook 'notmuch-message-mode-hook 'variable-pitch-mode)
  ;; (add-hook 'notmuch-message-mode-hook #'+mail/buffer-face-mode-notmuch)
  (add-hook 'notmuch-message-mode-hook (lambda () (set (make-local-variable 'company-backends) '(notmuch-company (company-ispell :with company-yasnippet)))))
  (add-hook 'notmuch-tree-mode-hook (lambda () (setq-local line-spacing nil)))
  (remove-hook 'message-mode-hook #'turn-on-auto-fill)
  (remove-hook 'notmuch-message-mode-hook #'turn-on-auto-fill)
  (after! evil-snipe
    (push 'notmuch-tree-mode evil-snipe-disabled-modes)
    (push 'notmuch-hello-mode evil-snipe-disabled-modes)
    (push 'notmuch-search-mode evil-snipe-disabled-modes)
    (push 'notmuch-show-mode evil-snipe-disabled-modes))
  (advice-add #'notmuch-start-notmuch-sentinel :override #'+mail/notmuch-start-notmuch-sentinel)
  (advice-add #'notmuch-show :override #'+mail/notmuch-show-reuse-buffer)
  (advice-add #'notmuch-hello-insert-searches :override #'+mail/notmuch-hello-insert-searches)
  (advice-add #'notmuch-hello-insert-saved-searches :override #'+mail/notmuch-hello-insert-saved-searches)
  (advice-add #'notmuch-hello-insert-buttons :override #'+mail/notmuch-hello-insert-buttons)
  ;; (set-popup-rule! "\\*notmuch-hello\\*" :size 20 :side 'left :quit t)
  (push (lambda (buf) (string-match-p "^\\*notmuch" (buffer-name buf)))
        doom-real-buffer-functions)

  (map! (:after notmuch
          (:map notmuch-show-mode-map
            :nmv "o"     #'ace-link-notmuch-show
            :nmv "i"     #'+mail/open-message-with-mail-app-notmuch-show
            :nmv "I"     #'notmuch-show-view-all-mime-parts
            :nmv "q"     #'notmuch-bury-or-kill-this-buffer
            :nmv "s"     #'counsel-notmuch
            :nmv "t"     #'notmuch-tree-from-show-current-query
            :nmv "s-n"   #'notmuch-mua-new-mail
            :nmv "n"     #'notmuch-show-next-thread-show
            :nmv "r"     #'notmuch-show-reply
            :nmv "<tab>" #'notmuch-show-toggle-visibility-headers
            :nmv "R"     #'notmuch-show-reply-sender
            :nmv "u"     #'+cole/notmuch-show-unsubscribe
            :nmv "p"     #'notmuch-show-previous-thread-show)
          (:map notmuch-hello-mode-map
            :nmv "o"   #'ace-link-notmuch-hello
            :nmv "t"   #'notmuch-tree
            :nmv "k"   #'widget-backward
            :nmv "n"   #'notmuch-mua-new-mail
            :nmv "s-n" #'notmuch-mua-new-mail
            :nmv "j"   #'widget-forward
            :nmv "s"   #'counsel-notmuch
            :nmv "q"   #'+mail/quit
            :nmv "e"   #'+mail/notmuch-update
            :nmv "r"   #'notmuch-hello-update)
          (:map notmuch-search-mode-map
            :nmv "j"   #'notmuch-search-next-thread
            :nmv "k"   #'notmuch-search-previous-thread
            :nmv "t"   #'notmuch-tree-from-search-thread
            ;; :nmv "RET"   #'notmuch-tree-from-search-thread
            :nmv "RET" #'notmuch-search-show-thread
            :nmv "s-n" #'notmuch-mua-new-mail
            :nmv "T"   #'notmuch-tree-from-search-current-query
            :nmv ";"   #'notmuch-search-tag
            :nmv "e"   #'+mail/notmuch-update
            :nmv ","   #'notmuch-jump-search
            :nmv "d"   #'+mail/notmuch-search-delete
            :nmv "a"   #'notmuch-search-archive-thread
            ;; :nmv "q"   #'notmuch
            :nmv "q"   #'+mail/quit
            :nmv "R"   #'notmuch-search-reply-to-thread-sender
            :nmv "r"   #'notmuch-search-reply-to-thread
            :nmv "s"   #'counsel-notmuch
            :nmv "S"   #'notmuch-search
            :nmv "x"   #'+mail/notmuch-search-spam)
          (:map notmuch-tree-mode-map
            :nmv "j"   #'notmuch-tree-next-message
            :nmv "k"   #'notmuch-tree-prev-message
            :nmv "S"   #'notmuch-search-from-tree-current-query
            :nmv "s"   #'counsel-notmuch
            :nmv "t"   #'notmuch-tree
            :nmv ";"   #'notmuch-tree-tag
            :nmv "RET" #'notmuch-tree-show-message
            :nmv "q"   #'notmuch-tree-quit
            :nmv "s-n" #'notmuch-mua-new-mail
            :nmv "r"   #'notmuch-search-reply-to-thread-sender
            :nmv "a"   #'notmuch-tree-archive-message-then-next
            :nmv "A"   #'notmuch-tree-archive-thread
            :nmv "i"   #'+mail/open-message-with-mail-app-notmuch-tree
            :nmv "d"   #'+mail/notmuch-tree-delete
            :nmv "x"   #'+mail/notmuch-tree-spam)
          (:map notmuch-message-mode-map
            :localleader
            :desc "Send and Exit"       :n doom-localleader-key #'notmuch-mua-send-and-exit
            :desc "Kill Message Buffer" :n "k" #'notmuch-mua-kill-buffer
            :desc "Save as Draft"       :n "s" #'message-dont-send
            :desc "Attach file" :n "f" #'mml-attach-file))))

(def-package! counsel-notmuch
  :commands counsel-notmuch
  :after notmuch)

(load! "org-notmuch")
(def-package! org-notmuch
  :after (org notmuch))

(def-package! org-mime
  :after (org notmuch)
  :config
  (setq org-mime-library 'mml
        org-mime-export-options '(:section-numbers nil :with-author nil :with-toc nil)))

