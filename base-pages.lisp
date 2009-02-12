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
	    (:body ,@body))))

(defun view-blog-posts ()
  (base-page (:title "Testing")
    (:h1 "My Blog")
    (loop for row in (cdr (third (get-all-posts-by-title)))
       collect (format t "<p>~a</p>"
		       (cdr (assoc :key row))))))