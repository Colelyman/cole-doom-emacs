;;; ~/.config/doom/autoload/windows.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +cole/close-popup ()
  "Close the popup window and return to the previous frame."
  (interactive)
  (evil-window-down 1)
  (quit-window))

;;;###autoload
(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

;;;###autoload
(defun +cole/reopen-killed-file ()
  "Pick a file to revisit from a list of files killed during this
Emacs session."
  (interactive)
  (if killed-file-list
      (let ((file (completing-read "Reopen killed file: " killed-file-list
                                   nil nil nil nil (car killed-file-list))))
        (when file
          (setq killed-file-list (cl-delete file killed-file-list :test #'equal))
          (find-file file)))
    (error "No recently-killed files to reopen")))
