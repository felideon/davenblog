(in-package :davenblog)

(defmacro with-html (&body body)
  `(with-html-output-to-string (*standard-output* nil :prologue nil :indent t)
     ,@body))

(defmacro base-page ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
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
  `(with-html
     (:div :class "post"
	   (:h2 (format t "~a" (cdr (assoc :title ,post))))
	   (:h3 (print-date (cdr (assoc :timestamp ,post))))
	   (:p (format t "~a" (cdr (assoc :body ,post))))
	   (:p :class "post-footer"
	       (format t "Posted by ~a" (cdr (assoc :author ,post)))
	       (:br)
	       (format t "Tags: ~{~:(~a~)~^, ~}"
		       (or (cdr (third ,post)) '("None")))
	       (:p
		(format t "~a comments"
			(count-comments (cdr (assoc :_id ,post)))))))))

(defun view-blog-posts ()
  (base-page (:title "My Blog")
    (dolist (row (reverse (cdr (third (get-all-posts-by-date)))))
      (format t "~a" (render-blog-post (cdr (third row)))))))

(defun new-post ()
  (base-page (:title "New Post")
    (:h2 "Add New Post")
    (:form :action "/submit_post" :method "post"
	   (:input :type "text" :name "title" :size "60")
	   (:p)
	   (:textarea :name "body" :rows "20" :cols "80")
	   (:p "Tags"
	       (:input :type "text" :name "tags" :size "20")
	       (:input :type "hidden" :name "author" :value "Felipe Delgado")
	       (:input :type "submit" :name "preview" :value "Preview")
	       (:input :type "submit" :name "publish" :value "Publish")))))

(defun preview-blog-entry (post)
  (base-page (:title "My Blog")
	     (format t "~a" (render-blog-post
			     (list (cons :author (nth 1 post))
				   (cons :body (nth 3 post))
				   (cons :tags (nth 4 post))
				   (cons :timestamp (nth 0 post))
				   (cons :title (nth 2 post)))))))

(defun view-entry ()
  (base-page (:title "My Blog")
    (format t "~a" (render-blog-post (get-post-by-id (parameter "id"))))
    (:p)
    (format t "~a" (comment-form))))

(defun comment-form ()
  (with-html
    (:h3 "Leave a Comment")
    (:form :action "/submit_comment" :method "post"
	   (:p "Name: "
	       (:input :type "text" :name "author" :size "20")
	       (:br)
	       (:textarea :name "body" :rows "5" :cols "30")
	       (:input :type "hidden" :name "post" :value (parameter "id"))
	       (:br)
	       (:input :type "submit" :value "Leave Comment")))))