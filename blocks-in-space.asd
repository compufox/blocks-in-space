;;;; blocks-in-space.asd

(asdf:defsystem #:blocks-in-space
  :description "Describe blocks-in-space here"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.0.1"
  :serial t
  :depends-on (#:str #:simple-config #:websocket-driver
               #:tooter #:deploy #:cl-json #:with-user-abort)
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "blocks-in-space"
  :entry-point "blocks-in-space:main"
  :components ((:file "package")
               (:file "blocks-in-space")))

