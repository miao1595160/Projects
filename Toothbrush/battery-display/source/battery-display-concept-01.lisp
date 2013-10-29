(in-package :E-Toothbrush)

(define-object battery-display-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (based-surface)
   (data-format "csv"     :settable) ; data-format
   
   (*new-file "data-01/"   :settable) ; data folder name
   (*exist-file "data-01/" :settable)
   
   (file-name-points "data-points") ; data file name
   (file-name-height "data-height") 
   
   (point-1 (nth 0 (the exist-data-points)) :settable)
   (point-3 (nth 1 (the exist-data-points)) :settable)  
   (point-5 (nth 2 (the exist-data-points)) :settable) 
   (point-7 (nth 3 (the exist-data-points)) :settable) 
   (height (the exist-data-height) :settable)
   
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
   (exist-file-names (list (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-points)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-height)
					     :type (the data-format)))))
   (exist-data-points (mapcar #'apply-make-point 
			(read-fare-csv          ; read csv file
			 (nth 0 (the exist-file-names)))))
   (exist-data-height (first
		       (first
			(read-fare-csv                 ; read csv file
			 (nth 1 (the exist-file-names))))))
   (*exist-data-save (progn 
		 (write-fare-csv           ; save current data
		  (mapcar #'(lambda (x) 
			      (array-to-list x E-Toothbrush::*global-accuracy*)) 
			  (list (the point-1) 
				(the point-3) 
				(the point-5) 
				(the point-7)))
		  (nth 0 (the exist-file-names)))
		 (write-fare-csv           ; save current data
			     (list (list (the height))) ;; all radius
			     (nth 1 (the exist-file-names)))))
   (new-file-names (list (merge-pathnames (the new-folder) 
					    (make-pathname 
					     :name (the file-name-points)
					     :type (the data-format)))
			   (merge-pathnames (the new-folder) 
					    (make-pathname 
					     :name (the file-name-height)
					     :type (the data-format)))))
   (*new-data-save (progn 
		 (write-fare-csv           ; save current data
		  (mapcar #'(lambda (x) 
			      (array-to-list x E-Toothbrush::*global-accuracy*)) 
			  (list (the point-1) 
				(the point-3) 
				(the point-5) 
				(the point-7)))
		  (nth 0 (the new-file-names)))
		 (write-fare-csv           ; save current data
			     (list (list (the height))) ;; all radius
			     (nth 1 (the new-file-names)))))
	       
   ;;12
   ;;34 
   ;5  6 
   ;7  8
   ;; point 6 8
   (6-x (- (get-x (the point-5))))
   (6-y (get-y    (the point-5)))
   (6-z (get-z    (the point-5)))
   (8-x (- (get-x (the point-7))))
   (8-y (get-y    (the point-7)))
   (8-z (get-z    (the point-7)))
   ;; point 2 4
   (2-x (- (get-x (the point-1))))
   (2-y (get-y    (the point-1)))
   (2-z (get-z    (the point-1)))
   (4-x (- (get-x (the point-3))))
   (4-y (get-y    (the point-3)))
   (4-z (get-z    (the point-3)))
   
   (vertex-list (list (the point-1)
		      (the point-3)
		      (the point-5)
		      (the point-7)
		      (make-point (the 8-x) (the 8-y) (the 8-z))
		      (make-point (the 6-x) (the 6-y) (the 6-z))
		      (make-point (the 4-x) (the 4-y) (the 4-z))
		      (make-point (the 2-x) (the 2-y) (the 2-z))
		      (the point-1)
		      )
		)
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
   (volume (/ (abs (getf (the line-swept-solid poly-brep brep precise-properties-plist) :volume)) 1000))
   )
  :objects
  (
   (line-global-polyline :type 'global-filleted-polyline-curve
			 :vertex-list (the vertex-list)
			 :default-radius 0.1
			 :hidden? t
			 ) 
   (line-projected :type 'projected-curves
		   :curve-in (the line-global-polyline)
		   :surface (the based-surface)
		   :projection-vector (make-vector 0 1 0)
		   :hidden? t
		   :approximation-tolerance 0.0001
		   )
   (line-top  :type 'boxed-curve
	      :curve-in (the line-projected (curves 1))
	      :center (translate (the-child curve-in center) 
				 :front (the height))
	      :display-controls (list :color :blue)
	      :hidden? t
	      )
   (line-trimmed :type 'trimmed-surface
		 :basis-surface (the based-surface)
		 :island (the line-projected (curves 1))
		 :hidden? t
		 ;; :display-controls (list :color :yellow :line-thickness 1)
		 )
   (line-swept-solid :type 'swept-solid
		     :distance (the height)
		     :facial-brep (the line-trimmed brep)
		     :vector (make-vector 0 -1 0)
		     )
   )
  )

