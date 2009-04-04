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

(push (create-prefix-dispatcher "/preview_post" 'preview-post)
      *dispatch-table*)

(start (make-instance 'acceptor :port 8080))

;; Global Constants
(defconstant day-names
  '("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"))

(defconstant month-names
  '("January" "February" "March" "April" "May" "June"
    "July" "August" "September" "October" "November" "December"))
