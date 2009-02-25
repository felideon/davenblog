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

(defun print-date (universal-time)
  (multiple-value-bind
	(second minute hour day month year day-of-week)
      (decode-universal-time universal-time)
    (declare (ignore second minute hour))
    (format t "~a, ~a ~d, ~d"
	    (nth day-of-week day-names)
	    (nth month month-names)
	    day
	    year)))

(defmacro render-blog-post (post)
  `(let ((post-value (cdr (third ,post))))
     (with-html
       (:div :class "post"
	(:h2 (format t "~a" (cdr (assoc :title post-value))))
	(:h3 (print-date (cdr (assoc :timestamp post-value))))
	(:p (format t "~a" (cdr (assoc :body post-value))))
	(:p :class "post-footer"
	    (format t "Posted by ~a" (cdr (assoc :author post-value)))
	    (:br)
	    (format t "Tags: ~{~a~^, ~}"
		    (or (cdr (third post-value))
			'("None"))))))))
  
(defun view-blog-posts ()
  (base-page (:title "My Blog")
    (dolist (row (reverse (cdr (third (get-all-posts-by-date)))))
      (format t "~a" (render-blog-post row)))))

(defun new-post ()
  (base-page (:title "New Post")
    (:h2 "Add New Post")
    (:form :action "/publish_post" :method "post"
	   (:input :type "text" :name "title" :size "60")
	   (:p)
	   (:textarea :name "body" :rows "20" :cols "80")
	   (:p "Tags"
	       (:input :type "text" :name "tags" :size "20")
	       (:input :type "hidden" :name "author" :value "Felipe Delgado")
	       (:input :type "button" :name "preview" :value "Preview")
	       (:input :type "submit" :value "Publish")
	       (:input :type "reset" :value "Clear Form")))))

(defun publish-post ()
  (let ((title (parameter "title"))
	(body (parameter "body"))
	(tags (parameter "tags"))
	(author (parameter "author")))
    (unless (and (or (null title) (zerop (length title)))
		 (or (null body) (zerop (length body))))
      (post-blog-entry (get-universal-time)
		       author
		       title
		       body
		       (split-tags tags))
    (redirect "/view_entries"))))

(defun split-tags (string)
  (loop for i = 0 then (1+ j)
       as j = (position #\, string :start i)
       collect (subseq string i j)
       while j))