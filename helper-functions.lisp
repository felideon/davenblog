(in-package :davenblog)

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

(defun valid-field-p (parameter)
  (not (or (null parameter) (zerop (length parameter)))))

(defun split-tags (string)
  (loop for i = 0 then (1+ j)
       as j = (position #\, string :start i)
       collect (subseq string i j)
       while j))

(defun comma-separate-tags (tags)
  (format t "~{~a~^,~}" tags))