;;; private/cole/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +cole/comment-or-uncomment-line ()
  "(Un)Comments a line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
