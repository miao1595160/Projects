(in-package :E-Toothbrush)

(define-object button-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (based-surface)
   
   (data-format "csv"      :settable) ; data-format
   
   (*new-file   "data-01/" :settable) ; data folder name
   (*exist-file "data-01/" :settable)
   
   (file-name-radius "data-radius" :settable)
   (file-name-height "data-height" :settable)
   (file-name-center "data-center" :settable)
   
   (radius (the exist-data-radius) :settable)
   (height (the exist-data-height) :settable)
   (center (the exist-data-center) :settable)
   
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
   (exist-file-names (list (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-center)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-height)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder)
					    (make-pathname 
					     :name (the file-name-radius)
					     :type (the data-format)))))
   (exist-data-center (first  
		       (mapcar #'apply-make-point                ; convert list to array
			       (read-fare-csv          ; read csv file
				(nth 0 (the exist-file-names))))))
   (exist-data-height (first
		       (first                           ; remove bracket
			(read-fare-csv          ; read csv file
			 (nth 1 (the exist-file-names))))))
   (exist-data-radius (first
		       (first                           ; remove bracket
			(read-fare-csv          ; read csv file
			 (nth 2 (the exist-file-names))))))
   (*exist-data-save (progn 
		       (write-fare-csv            ; save new data
			(list (array-to-list (the center) E-Toothbrush::*global-accuracy*)) ; array to list accuracy up to 1.0e-3
			(nth 0 (the exist-file-names)))
		       (write-fare-csv            ; save new data
		        (list (list (the height)))           ; array to list
			(nth 1 (the exist-file-names)))
		       (write-fare-csv            ; save new data
		        (list (list (the radius)))          ; array to list
			(nth 2 (the exist-file-names)))))
   (new-file-names (list (merge-pathnames (the new-folder) 
					    (make-pathname 
					     :name (the file-name-center)
					     :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-height)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder)
					  (make-pathname 
					   :name (the file-name-radius)
					   :type (the data-format)))))
    (*new-data-save (progn 
		       (write-fare-csv            ; save new data
			(list (array-to-list (the center) E-Toothbrush::*global-accuracy*)) ; array to list accuracy up to 1.0e-3
			(nth 0 (the new-file-names)))
		       (write-fare-csv            ; save new data
		        (list (list (the height)))           ; array to list
			(nth 1 (the new-file-names)))
		       (write-fare-csv            ; save new data
		        (list (list (the radius)))          ; array to list
			(nth 2 (the new-file-names)))))
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
   (volume (/ (getf (the button-swept-solid poly-brep brep precise-properties-plist) :volume) 1000))
   )
  :objects
  (   
   (button-circle :type 'arc-curve
		  :radius (the radius)
		  :center (the center)
		  :orientation (alignment 
				:top (rotate-vector-d (the z-vector)
						      90
						      (the x-vector)))
		  :display-controls (list :color :red :line-thickness 2)
		  :hidden? t
		  )
   (button-projected :type 'projected-curves
		     :curve-in (the button-circle)
		     :surface (the based-surface)
		     :projection-vector (make-vector 0 1 0)
		     :display-controls (list :color :red :line-thickness 1)
		     :approximation-tolerance 0.0001
		     :hidden? t
		     )
   (button-trimmed :type 'trimmed-surface
		   :island (the button-projected (curves 1))
		   :basis-surface (the based-surface)
		   :hidden? t
		   )
   (button-swept-solid :type 'swept-solid
		       :distance (the height)
		       :facial-brep (the button-trimmed brep)
		       :vector (make-vector 0 -1 0)
		       )
   )
  )

