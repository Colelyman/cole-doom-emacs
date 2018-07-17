;;; ~/.config/doom/autoload/windows.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +cole/close-popup ()
  "Close the popup window and return to the previous frame."
  (interactive)
  (evil-window-down 1)
  (quit-window))
