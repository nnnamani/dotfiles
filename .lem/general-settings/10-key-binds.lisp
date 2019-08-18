(in-package :lem)

;; Key Bindings
(define-key *global-keymap* "Return" 'lem.language-mode:newline-and-indent)
(setf *scroll-recenter-p* nil)

(define-key *global-keymap* "C-t" 'other-window)
(define-key *global-keymap* "M-i" 'delete-other-windows)
(define-key *global-keymap* "M-z" 'query-replace)
(define-key *global-keymap* "M-u" 'redo)
(define-key *global-keymap* "C-u" 'undo)
(define-key *global-keymap* "C-x l" 'start-lisp-repl)
