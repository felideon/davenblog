(defpackage #:davenblog
  (:use #:cl #:hunchentoot #:cl-who
	#:cl-couchdb-client #:cl-couchdb-view-server #:cl-couchdb-object-layer)
  (:shadowing-import-from #:cl-couchdb-client #:url-encode :url-decode))