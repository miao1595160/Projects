(in-package :E-Toothbrush)

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

(defun bounding-box-distance (bounding-box)
  (let*
      (
       (v1-x (get-x (nth 0 bounding-box)))
       (v1-y (get-y (nth 0 bounding-box)))
       (v1-z (get-z (nth 0 bounding-box)))
       
       (v2-x (get-x (nth 1 bounding-box)))
       (v2-y (get-y (nth 1 bounding-box)))
       (v2-z (get-z (nth 1 bounding-box)))

       (x (- v2-x v1-x))
       (y (- v2-y v1-y))
       (z (- v2-z v1-z))
       )
    (list  x y z)
    )
  )
    
