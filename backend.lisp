(in-package :davenblog)

(defun create-davenblog-db ()
  (create-database "davenblog"))

(defun canonicalize-field (keyvalue)
  (cons (car keyvalue) (cadr keyvalue)))

(defun post-blog-entry (timestamp subject tags content)
  (couch-request :post (davenblog) (mapcar #'canonicalize-field
						 `(("timestamp" ,timestamp)
						  ("subject" ,(car subject))
						  ("tags" ,tags)
						  ("content" ,(car content))))))