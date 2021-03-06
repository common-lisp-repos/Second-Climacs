(cl:in-package #:asdf-user)

(defsystem :climacs-syntax-common-lisp-indentation
  :depends-on (:climacs-syntax-common-lisp-base)
  :serial t
  :components
  ((:file "indentation-support")
   (:file "define-indentation-defmacro")
   (:file "let-and-letstar")
   (:file "setf-and-setq")
   (:file "eval-when")
   (:file "prog1-etc")
   (:file "block-etc")
   (:file "locally")
   (:file "tagbody")
   (:file "multiple-value-setq")
   (:file "lambda-list")
   (:file "flet-labels-macrolet")
   (:file "defun")
   (:file "destructuring-bind-etc")
   (:file "make-instance-etc")
   (:file "defclass")))
