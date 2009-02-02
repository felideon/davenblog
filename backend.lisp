(in-package :davenblog)

(defun create-davenblog-db ()
  (create-database "davenblog"))

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