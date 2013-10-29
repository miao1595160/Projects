(in-package :E-Toothbrush)

(define-object head-concept-02 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv" :settable)        ; data-format

   (*new-file "data-01/"   :settable)
   (*exist-file "data-01/" :settable)   ; data file name
   
   (file-name "data") ; data file name
   
   (distance (nth 0 (the exist-data)) :settable)
   (r1 (nth 1 (the exist-data)) :settable)
   (r2 (nth 2 (the exist-data)) :settable)
   
   (select-material "plastic/duralumin" :settable)
   )
  :computed-slots
  (
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
		(mapcar #'list (list (the distance)
				     (the r1)
				     (the r2)))
		(the exist-file-name)))
   (new-file-name (merge-pathnames (the new-folder) 
				     (make-pathname 
				      :name (the file-name)
				      :type (the data-format))))
   
   (new-data (flatten                   ; remove bracket
		(read-fare-csv  ; read csv file
		 (the new-file-name))))
   (*new-data-save (write-fare-csv    ; save current data
		(mapcar #'list (list (the distance)
				     (the r1)
				     (the r2)))
		(the new-file-name)))
   (neck-center  (first                    ; remove bracket
		  (last                    ; get last element
		   (list-elements (the neck concept-01 circles) (the-element center))))) ; get all elements
   (neck-height (first                     ; remove bracket
		 (last                     ; get last element
		  (list-elements (the neck concept-01 circles) (the-element radius)))))
   (center-01 (make-point 
	       (get-x (the neck-center))
	       (+ (get-y (the neck-center)) (the neck-height))
	       (+ (the r1)
		  (get-z (the neck-center)))))                  
   (center-02 (make-point 
	       (get-x (the neck-center))
	       (+ (get-y (the neck-center)) (the neck-height))
	       (+ (the distance)
		  (get-z (the neck-center))))) 
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
   (volume (/ (getf (the head-extruded poly-brep brep precise-properties-plist) :volume) 1000))
   ;; surface for clearance-swept-solid
   (face-for-cle-dis (mapcar #'(lambda(face)
				 (list (the-object face index)
				       (3d-distance (the center) 
						    (apply #'midpoint  (the-object face bounding-box)))))
			     (list-elements (the head-extruded faces))))
   (face-for-cle-index (first (least #'second (the face-for-cle-dis))))
   (face-for-clearance (the head-extruded (faces (the face-for-cle-index))))
   ;; edges for bristle
   (face-for-bri-ref (translate (the-object (nth 3 (list-elements (the neck concept-01 circles))) center) 
				 :up (+ (half (3d-distance (the center-01) (the center-02)))
					(the r2))
				 :front (first (last (list-elements (the neck concept-01 circles) (the-element radius))))))
   (face-for-bri-dis (mapcar #'(lambda(face)
				  (list (the-object face index)
					(3d-distance (the face-for-bri-ref)
						     (apply #'midpoint  (the-object face bounding-box)))))
			      (list-elements (the head-extruded faces))))
   (face-for-bri-index (first (least #'second (the face-for-bri-dis))))
   (face-for-bri (the head-extruded (faces (the face-for-bri-index))))
   (edges-for-bri (list-elements (the face-for-bri edges)))
   )
  :objects
  (   
   (head-tangent-circles :type 'head-tangent-circles
			 :r1 (the r1)
			 :r2 (the r2)
			 :center-01 (the center-01)
			 :center-02 (the center-02)
			 :hidden? t
			 )
   (head-extruded :type 'extruded-solid 
                  :profile (the head-tangent-circles composed-curve)
		  :distance (* 2 (first                     ;; y
				  (last                  
				   (list-elements (the neck concept-01 circles) (the-element radius)))))
                  :axis-vector (make-vector 0 -1 0)
		  )
   
   )
  )
