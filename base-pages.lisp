(in-package :davenblog)

(defmacro with-html (&body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     ,@body))

(defmacro base-page ((&key title) &body body)
  `(with-html
     (:html :xmlns "http://www.w3.org/1999/xhtml"
	    :xml\:lang "en" 
	    :lang "en"
	    (:head 
	     (:meta :http-equiv "Content-Type"
		    :content "text/html"
		    :charset "utf-8")
	     (:title ,title)
	     (:link :rel "stylesheet" :type "text/css" :href "/css/base.css"))
	    (:body
	     (:h1 "My Blog")
	     ,@body))))

(defmacro render-blog-post (post)
  `(let ((post-value (cdr (third ,post))))
     (format t "<h2>~a</h2><p>~a</p>"
	     (cdr (assoc :title post-value))
	     (cdr (assoc :body post-value)))))

(defun view-blog-posts ()
  (base-page (:title "My Blog")
    (loop for row in (reverse (cdr (third (get-all-posts-by-date))))
       do (render-blog-post row))))

	 ;(format t "<p>~a</p>"
	 ;(cdr (assoc :key row))))))

(defun new-post ()
  (base-page (:title "New Post")
    (:h2 "Add New Post")
    (:form :action "/publish_post" :method "post"
	   (:input :type "text" :name "title" :size "80")
	   (:p)
	   (:textarea :name "body" :rows "20" :cols "80") (:br)
	   (:input :type "submit" :value "Publish")
	   (:input :type "reset" :value "Clear Form"))))

(defun publish-post ()
  (let ((title (parameter "title"))
	(body (parameter "body")))
    (unless (and (or (null title) (zerop (length title)))
		 (or (null body) (zerop (length body))))
      (post-blog-entry (get-universal-time)
		       "Felipe Delgado"
		       title
		       body
		       '()))
    (redirect "/view_entries")))