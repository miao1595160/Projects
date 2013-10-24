(in-package :E-Toothbrush)

(define-object motor (base-object) 
  :input-slots 
  (
   (data)
   (exist-file-names)
   (load)
    ;; read data from source file directly for adjustment motor
   (motor-file-number   (nth 0 (flatten (read-fare-csv (nth 2 (the exist-file-names))))) :settable) 
  
   (dis-motor-gear      (nth 1 (the data)) :settable)
   
   (motor-file-path "data/motor library/") 
   (motor-list-name "motor list")
   (motor-list-format "csv"  :settable)
   (motor-file-name (nth (the motor-file-number) (the motor-list)) :settable)
   (motor-file-format "stp" :settable)
   )
  :computed-slots
  (
   ;; motor library path
   (motor-folder (merge-three-paths *path-name* (the drive drive-file-path) (the motor-file-path)))
   (motor-list (mapcar #'string (flatten (read-fare-csv (merge-pathnames (the motor-folder) 
									 (make-pathname 
									  :name (the motor-list-name)
									  :type (the motor-list-format)))))))
   ;; adjust motor when handle get smaller
   (*motor-adjustment (let
			  ((*motor-file-number (the motor-file-number)))
			(loop (when (or (not (loop for j in 
						  (loop for i in (list-elements (the motor face-breps))
						     collect (the handle handle-surface-brep (brep-intersect? i)))
						do (if (equal j t)
						       (return t))))
					(<= *motor-file-number 0))
				(return))
			   (write-fare-csv                   
			    (mapcar #'list (list (decf *motor-file-number)
						 (the dis-motor-gear)))
			    (nth 2 (the exist-file-names)))
			   (the update!))))
   (motor-radius (/ (- (get-x (nth 1 (the motor bounding-box)))
		       (get-x (nth 0 (the motor bounding-box)))) 2))
   (motor-length (- (get-z (nth 1 (the motor bounding-box)))
		     (get-z (nth 0 (the motor bounding-box)))))
   )
  :objects
  (
   (motor-step :type 'step-reader
	       :file-name (merge-pathnames (the motor-folder) 
					   (make-pathname 
					    :name (the motor-file-name)
					    :type (the motor-file-format)))
	       :hidden? t
	       )
   (motor :type 'transformed-solid
	  :brep (the motor-step (breps 0))
	  :from-object (the bars drive-bar)
	  :to-location (translate (the gears motor-gear (face-center :front)) 
				  :down (+ (the dis-motor-gear)))
	  :display-controls (list :color :magenta)
	  )
   (AHP-motor :type 'motor-AHP
	      :load (the load)
	      :diameter (the motor-radius)
	      )
   )
  )

