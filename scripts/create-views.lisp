;;; Simple script that sets up the Davenblog database.

(in-package :davenblog)

(defdesign blog-entries
    ((posts-by-timestamp
      :map (doc)
      (when (string= (@ doc :type) "DAVENBLOG::BLOG-POST")
	(emit (@ doc :timestamp) doc)))
     (posts-and-comments
      :map (doc)
      (cond ((string= (@ doc :type) "DAVENBLOG::BLOG-POST")
	     (emit (list (@ doc :_id) 0 (@ doc :timestamp)) doc))
	    ((string= (@ doc :type) "DAVENBLOG::COMMENT")
	     (emit (list (@ doc :post) 1 (@ doc :timestamp)) doc)))))
  (:documentation "Views for returning collated entries and comments.")
  (:sync davenblog))