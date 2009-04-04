(asdf:defsystem #:davenblog
  :name "davenblog"
  :depends-on (#:cl-couch #:hunchentoot #:cl-who)
  :components ((:file "package")
	       (:file "backend"
		      :depends-on ("package"))
	       (:file "helper-functions"
		      :depends-on ("package"))
	       (:file "base-pages"
		      :depends-on ("backend")
		      :depends-on ("helper-functions"))))