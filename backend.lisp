(in-package :davenblog)

(defun create-davenblog-db ()
  (create-database "davenblog"))

(defun create-design-doc-all-posts ()
  (defdesign all-posts
      ((all-post-titles :map (doc)
			(when (string= (@ doc :type) "DAVENBLOG::BLOG-POST")
			  (emit (@ doc :title) doc)))
       (all-post-dates :map (doc)
		       (when (string= (@ doc :type) "DAVENBLOG::BLOG-POST")
			 (emit (@ doc :timestamp) doc))))
    (:documentation "Views for returning all blog posts.")
    (:sync davenblog)))


(defdoc blog-post
    ((:timestamp :validator #'numberp)
     (:author :validator #'stringp)
     (:title :validator #'stringp)
     (:body :validator #'stringp)
     (:tags :validator #'listp))
  (:default-db 'davenblog))

(defun post-blog-entry (timestamp author title body tags)
  (make-doc-and-save 'blog-post
		     :timestamp timestamp
		     :author author
		     :title title
		     :body body
		     :tags tags))

(defmacro get-all-posts ((&key view) &body body)
  `(couch-request :get ,(append '(davenblog/_view/all_posts/) view body)))

(defun get-all-posts-by-title ()
  (get-all-posts (:view (all_post_titles))))

(defun get-all-posts-by-date ()
  (get-all-posts (:view (all_post_dates))))