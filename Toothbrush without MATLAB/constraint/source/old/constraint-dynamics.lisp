(in-package :E-Toothbrush)

(define-object constraint-dynamics (base-object) 
  :input-slots 
  (
   (head-angle-threshold (the exist-data-head-angle) :settable)
   (constraint-file-path "constraint dynamic/data/" :settable)
   (data-format     "csv"                   :settable)
   (exist-file-path "data-01/"              :settable)
   (new-file-path   "data-01/"              :settable)

   (file-head-angle    "data-head-angle"    :settable)
   )
  :computed-slots
  (
   (folder-list (cl-fad::list-directory 
		  (merge-pathnames (the constraint-file-path)  *path-name*))) ;; list of all data files
   (exist-folder (merge-three-paths *path-name* (the constraint-file-path) (the exist-file-path)))
   (new-folder (merge-three-paths *path-name* (the constraint-file-path) (the new-file-path)))
   (new-folder? (if (not (search-file-in-path-list (the new-folder) (the *folder-list)))
		     (ensure-directories-exist (the new-folder))                          ;; if it doesn't exist, create it.
		     (search-file-in-path-list (the exist-folder) (the *folder-list)))) ;; if exist, use it.
   
   (exist-file-head-angle (merge-pathnames (the exist-folder) 
					   (make-pathname 
					    :name (the file-head-angle)
					    :type (the data-format))))
  
   (exist-data-head-angle (first (first (read-fare-csv          ; read csv file
					 (the exist-file-head-angle)))))
   (exist-data-save  (write-fare-csv            ; save current data
		       (list (list (the head-angle-threshold)))
		       (the exist-file-head-angle)))
   (new-file-head-angle (merge-pathnames (the new-folder) 
					   (make-pathname 
					    :name (the file-head-angle)
					    :type (the data-format))))
   (new-data-save  (write-fare-csv            ; save current data
		       (list (list (the head-angle-threshold)))
		       (the new-file-head-angle)))
   (*head-angle-check (if (> (the MATLAB *sim-case-head-angle) (the head-angle-threshold))
			  (format nil "Due to the consideration of comfort, the head should be limited in  ~D mm." (the head-angle-threshold))
			  (format nil "The contraint is satisfied")))
   ;; motion check
   (length-bar1 (3d-distance (the drive follow-gear (face-center :rear)) (the drive bar1 bar-start)))
   (length-bar2 (3d-distance (the drive bar2 bar-start) (the drive bar2 bar-end)))
   (length-bar3 (3d-distance (the drive bar3 bar-start) (the drive bar3 bar-end)))
   (length-motor-gear (3d-distance (the drive motor-gear (face-center :rear)) (the drive follow-gear (face-center :rear))))
  

   (*circular-motion-check (if (or (> (the length-bar1) (the length-bar2)) 
				   (> (the length-bar1) (the length-bar3))
				   (> (the length-bar1) (the length-motor-gear)))
			       (format nil "The circular motion cannot be completed. The crank is not the shortest stick")
			       (if (< (+ (the length-bar1) (max (the length-bar2) (the length-bar3) (the length-motor-gear)))
				       (cond 
					 ((equal (max (the length-bar2) (the length-bar3) (the length-motor-gear)) (the length-bar2)) 
					  (+ (the length-bar3) (the length-motor-gear))) 
					 ((equal (max (the length-bar2) (the length-bar3) (the length-motor-gear)) (the length-bar3)) 
					  (+ (the length-bar2) (the length-motor-gear)))
					 ((equal (max (the length-bar2) (the length-bar3) (the length-motor-gear)) (the length-motor-gear)) 
					  (+ (the length-bar2) (the length-bar3)))))
				   (format nil "The contraint is satisfied")
				   (format nil "The sum of the shortest and longest sticks should be lower than the sum of others."))))
   )
  )


