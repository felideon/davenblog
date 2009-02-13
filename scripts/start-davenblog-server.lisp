;;; Simple script that starts the Davenblog server backend.

(in-package :davenblog)

;; CouchDB
(open-server)
(start-view-server)

;; Start Hunchentoot

(push (create-folder-dispatcher-and-handler
       "/css/"
       #p"/Users/felipe/.hacking/lisp/projects/davenblog/css/"
       "text/css")
      *dispatch-table*)

(push (create-prefix-dispatcher "/view_entries" 'view-blog-posts)
      *dispatch-table*)

(push (create-prefix-dispatcher "/new_post" 'new-post)
      *dispatch-table*)

(push (create-prefix-dispatcher "/publish_post" 'publish-post)
      *dispatch-table*)

(defparameter *web-server* (start-server :port 8080))