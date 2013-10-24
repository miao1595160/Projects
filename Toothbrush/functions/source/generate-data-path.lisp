(in-package :E-Toothbrush)
;; merge three paths together
;; #P"D:\\Dropbox\\GDL\\Examples\\data\\nurbs-lofted-surface\\"
(defun merge-three-paths (first-path second-path third-path)
  (let 
      (
       (first-second-path  ())
       (total-path ())
       )
    (setf first-second-path 
	  (merge-pathnames second-path
			   (make-pathname :name nil
					  :type nil
					  :defaults first-path)))
    (setf total-path 
	  (merge-pathnames third-path
			   (make-pathname :name nil
					  :type nil
					  :defaults first-second-path)))
    (print total-path)))

(defun search-file-in-path-list (object path-list)
  (let
      (
       (output nil)
       (j 0)
       )
    (loop (when (>= j (length path-list)) (return))
       (if (cl-fad:pathname-equal object (nth j path-list))
	   (progn (setf output (nth j path-list))
		  (setf j (length path-list)))
	   (progn 
	     (setf output nil)
	     (incf j)))
       )
    (print output)
    )
  )
