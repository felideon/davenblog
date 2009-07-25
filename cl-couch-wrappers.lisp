(in-package :davenblog)

(defdoc blog-post
    ((:timestamp :validator #'numberp)
     (:author :validator #'stringp)
     (:title :validator #'stringp)
     (:body :validator #'stringp)
     (:tags :validator #'listp))
  (:default-db 'davenblog))

(defdoc comment
    ((:timestamp :validator #'numberp)
     (:author :validator #'stringp)
     (:body :validator #'stringp)
     (:post :validator #'stringp))
  (:default-db 'davenblog))

(defun post-blog-entry (post)
  (make-doc-and-save 'blog-post
		     :timestamp (nth 0 post)
		     :author (nth 1 post)
		     :title (nth 2 post)
		     :body (nth 3 post)
		     :tags (nth 4 post)))

(defun post-comment (comment)
  (make-doc-and-save 'comment
		     :timestamp (nth 0 comment)
		     :author (nth 1 comment)
		     :body (nth 2 comment)
		     :post (nth 3 comment)))

(defun get-all-posts-by-date ()
  (couch-request* :get *couchdb-server* 
		  '(davenblog _view blog_entries posts_by_timestamp)))

(defun get-post-and-comments (id)
  (couch-request* :get *couchdb-server*
		  '(davenblog _view blog_entries posts_and_comments)
		  (cl-couchdb-view-server::prepare-keys
		   (list :startkey (list id) :endkey (list id 2)))))

(defun get-post-by-id (id)
  (couch-request* :get *couchdb-server* `(davenblog ,id)))