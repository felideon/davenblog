;;; Simple script that sets up the Davenblog database.

(in-package :davenblog)

;; Create database and design documents.
(create-davenblog-db)
(create-design-doc-all-blog-posts)