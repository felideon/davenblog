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
		       (or (cdr (third ,post))
			   '("None")))))))
  
(defun view-blog-posts ()
  (base-page (:title "My Blog")
    (dolist (row (reverse (cdr (third (get-all-posts-by-date)))))
      (format t "~a" (render-blog-post (cdr (third row)))))))

(defun new-post ()
  (base-page (:title "New Post")
    (:h2 "Add New Post")
    (:form :action "/preview_post" :method "post"
	   (:input :type "text" :name "title" :size "60")
	   (:p)
	   (:textarea :name "body" :rows "20" :cols "80")
	   (:p "Tags"
	       (:input :type "text" :name "tags" :size "20")
	       (:input :type "hidden" :name "author" :value "Felipe Delgado")
	       (:input :type "submit" :name "preview" :value "Preview")
	       (:input :type "submit" :name "publish" :value "Publish")))))

(defun preview-post ()
  (let ((time (get-universal-time))
	(title (parameter "title"))
	(body (parameter "body"))
	(tags (parameter "tags"))
	(author (parameter "author"))
	(publish (parameter "publish")))
    (when (and (valid-field-p title) (valid-field-p body))
      (let ((post (list time author title body (split-tags tags))))
	(if (valid-field-p publish)
	    (progn 
	      (post-blog-entry post)
	      (redirect "/view_entries"))
	    (preview-blog-entry post))))))


(defun preview-blog-entry (post)
  (let ((author (nth 1 post))
	(body (nth 3 post))
	(tags (nth 4 post))
	(timestamp (nth 0 post))
	(title (nth 2 post)))
    (base-page (:title "My Blog")
      (format t "~a" (render-blog-post
		      (list (cons :author author)
			    (cons :body body)
			    (cons :tags tags)
			    (cons :timestamp timestamp)
			    (cons :title title)))))))
      ;(:form :action "/preview_post" :method "post"
	     ;(:input :type "hidden" :name "author" :value author)
	     ;(:input :type "hidden" :name "body" :value body)
	     ;(:input :type "hidden" :name "tags" :value tags)
	     ;(:input :type "hidden" :name "timestamp" :value timestamp)
	     ;(:input :type "hidden" :name "title" :value title)
	     ;(:input :type "submit" :name "publish" :value "Publish")))))