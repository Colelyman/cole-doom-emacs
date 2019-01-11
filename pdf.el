;;; ~/.config/doom/pdf.el -*- lexical-binding: t; -*-

(map! (:after pdf-tools-modes
        (:map pdf-view-mode-map
          :nmveo "J" #'(lambda () (evil-collection-pdf-view-next-line-or-next-page 10))
          :nmveo "K" #'(lambda () (evil-collection-pdf-view-previous-line-or-previous-page 10))
          :nmveo "i" #'interleave-add-note)))
