(asdf:defsystem #:davenblog
  :depends-on (#:cl-couch #:hunchentoot #:cl-who)
  :components ((:file "package")
	       (:file "backend" :depends-on ("package"))))