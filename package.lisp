(defpackage #:davenblog
  (:use #:cl #:cl-couchdb-client #:hunchentoot #:cl-who)
  (:shadowing-import-from #:cl-couchdb-client #:url-encode :url-decode))