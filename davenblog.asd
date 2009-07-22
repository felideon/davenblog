(asdf:defsystem #:davenblog
  :name "davenblog"
  :depends-on (#:cl-couch #:hunchentoot #:cl-who)
  :components ((:file "package")
	       (:file "cl-couch-wrappers"
		      :depends-on ("package"))
	       (:file "helper-functions"
		      :depends-on ("package"))
	       (:file "page-actions"
		      :depends-on ("cl-couch-wrappers")
		      :depends-on ("helper-functions"))
	       (:file "base-page-handlers"
		      :depends-on ("page-actions"))))