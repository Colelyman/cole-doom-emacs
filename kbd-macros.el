;;; private/cole/kbd-macros.el -*- lexical-binding: t; -*-

(fset 'c-cast-from-alloc
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([36 70 102 108 108 121 105 40 70 61 97 32 40 escape 112 97 42 41 escape 106] 0 "%d")) arg)))

