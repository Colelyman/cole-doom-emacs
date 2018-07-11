;;; ~/.config/doom/autoload/org.el -*- lexical-binding: t; -*-

;;;###autoload
(defun org-hugo-new-subtree-post-capture-template ()
  "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information. Based off of
the function found: https://ox-hugo.scripter.co/doc/org-capture-setup"
  (let* ((title (read-from-minibuffer "Post Title: "))
         (fname (org-hugo-slug title)))
    (mapconcat #'identity
               `(
                 ,(concat "** TODO " title)
                 ":PROPERTIES:"
                 ,(concat "  :EXPORT_FILE_NAME: " fname)
                 ":END:"
                 "%?\n")
               "\n")))
