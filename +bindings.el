;;; private/cole/+bindings.el -*- lexical-binding: t; -*-

(map!
 ;; Global keybindings, available in all modes
 "M-s" 'save-buffer
 ;; Keybindings available in the leader
 (:leader
   ;; Code keybindings
   (:prefix "c"
     :desc "(Un)Comment line" :n "c" #'+cole/comment-or-uncomment-line)
   ;; Window keybindings
   (:prefix "w"
    :desc "Close current window" :n "d" #'+workspace/close-window-or-workspace)))

