(in-package :E-Toothbrush)

(define-object head-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv" :settable)       ; data-format
   
   (*new-file "data-01/"   :settable)
   (*exist-file "data-01/" :settable)   ; data file name
   
   (file-name "data") ; data file name

   (motor-radius           (nth 0 (the exist-data)) :settable)
   (head-ellipse-max       (nth 1 (the exist-data)) :settable)
   (head-ellipse-min       (nth 2 (the exist-data)) :settable)
   (head-extruded-distance (nth 3 (the exist-data)) :settable)
   
   (height (* (the data-height) 2))
   
   (select-material "plastic/duralumin" :settable)
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   
   (*folder-list (cl-fad::list-directory  ; get file path with file name
		  (the path)))
   (exist-folder (merge-pathnames (the *exist-file)
				  (make-pathname :name nil
						 :type nil
						 :defaults (the path))))
   (*new-folder? (if (not (search-file-in-path-list (the new-folder) (the *folder-list)))
		     (ensure-directories-exist (the new-folder))                          ;; if it doesn't exist, create it.
		     (search-file-in-path-list (the exist-folder) (the *folder-list))))   ;; otherwise, get it.
   (new-folder (merge-pathnames (the *new-file)
				(make-pathname :name nil
					       :type nil
					       :defaults (the path))))
   (exist-file-name (merge-pathnames (the exist-folder) 
				     (make-pathname 
				      :name (the file-name)
				      :type (the data-format))))
   
   (exist-data (flatten                   ; remove bracket
		(read-fare-csv  ; read csv file
		 (the exist-file-name))))
   (*exist-data-save (write-fare-csv    ; save current data
		      (mapcar #'list (list (the motor-radius)
					   (the head-ellipse-max)
					   (the head-ellipse-min)
					   (the head-extruded-distance)))
		      (the exist-file-name)))
   (new-file-name (merge-pathnames (the new-folder) 
				    (make-pathname 
				     :name (the file-name)
				     :type (the data-format))))
   (new-data (flatten                   ; remove bracket
		(read-fare-csv  ; read csv file
		 (the new-file-name))))
   (*new-data-save (write-fare-csv    ; save current data
		      (mapcar #'list (list (the motor-radius)
					   (the head-ellipse-max)
					   (the head-ellipse-min)
					   (the head-extruded-distance)))
		      (the new-file-name)))
   
   (data-height (first                     ; remove bracket
		 (last                     ; get last element
		  (list-elements (the neck concept-01 circles) (the-element radius))))) ; get all elements
   (data-center  (first                    ; remove bracket
		  (last                    ; get last element
		   (list-elements (the neck concept-01 circles) (the-element center))))) ; get all elements
   ;; density [g/cm^3]
   (material-density (cond 
		       ((string= (the select-material) "plastic") (the material plastic density))
		       ((string= (the select-material) "duralumin") (the material duralumin density))
		       (t (the material plastic density))))
   ;; cost [USD/g]
   (material-cost (cond 
		       ((string= (the select-material) "plastic") (the material plastic cost))
		       ((string= (the select-material) "duralumin") (the material duralumin cost))
		       (t (the material plastic cost))))
   ;; volume [cm^3]
   (volume (/ (+ (getf (the motor-cylinder poly-brep brep precise-properties-plist) :volume)
		 (getf (the head-extruded poly-brep brep precise-properties-plist) :volume)) 1000))
   )
  :objects
  (   
   (motor-cylinder :type 'cone-solid
		   :radius-1 (the motor-radius)
		   :radius-2 (the motor-radius)
		   :length (the height)
		   :center (make-point 
			    (get-x (the data-center))
			    (get-y (the data-center))
			    (+ (the motor-radius)
			       (get-z (the data-center)))) ; refer to the neck toppest circle
		   )
   (head-ellipse :type 'elliptical-curve
		 :center (the motor-cylinder (face-center :front))
		 :major-axis-length (* (the head-ellipse-max) 2)
		 :minor-axis-length (* (the head-ellipse-min) 2)
		 :start-angle 0
		 :end-angle 2pi
		 :orientation (alignment 
				:top  (rotate-vector-d (the z-vector)
						      90
						      (the x-vector))
				:rear (rotate-vector-d (the y-vector)
						      90
						      (the z-vector)))
		 :hidden? t
		 )
   (head-extruded :type 'extruded-solid 
                  :profile (the head-ellipse)
		  :distance (the head-extruded-distance)
                  :axis-vector (make-vector 0 -1 0)
		  )
   )
  )

