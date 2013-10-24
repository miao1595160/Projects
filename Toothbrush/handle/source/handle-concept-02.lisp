(in-package :E-Toothbrush)
(define-object handle-concept-02 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv"     :settable) ; data-format
   
   (new-file "data-01/"   :settable) ; data folder name
   (exist-file "data-01/" :settable)

   (file-name-p1s "data-p1s") ; data file name
   (file-name-p2s "data-p2s")
   (file-name-r1s "data-r1s")
   (file-name-r2s "data-r2s")

   (p1s (the exist-data-p1s) :settable)
   (p2s (the exist-data-p2s) :settable)
   (r1s (the exist-data-r1s) :settable)
   (r2s (the exist-data-r2s) :settable)
   
   (select-material "plastic/duralumin" :settable)
   )
  :computed-slots
  (
   (*folder-list (cl-fad::list-directory  ; get file path with file name
		  (the path)))
   (exist-folder (merge-pathnames (the exist-file)
				  (make-pathname :name nil
						 :type nil
						 :defaults (the path))))
   (*new-folder? (if (not (search-file-in-path-list (the new-folder) (the *folder-list)))
		     (ensure-directories-exist (the new-folder))                          ;; if it doesn't exist, create it.
		     (search-file-in-path-list (the exist-folder) (the *folder-list))))   ;; otherwise, get it.
   (new-folder (merge-pathnames (the new-file)
				(make-pathname :name nil
					       :type nil
					       :defaults (the path))))
   
   (exist-file-names (list (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-p1s)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-p2s)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder)
					    (make-pathname 
					     :name (the file-name-r1s)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder)
					    (make-pathname 
					     :name (the file-name-r2s)
					     :type (the data-format)))))
   (exist-data-p1s (mapcar #'apply-make-point                ; convert list to array
			     (read-fare-csv          ; read csv file
			      (nth 0 (the exist-file-names)))))
   (exist-data-p2s (mapcar #'apply-make-point                ; convert list to array
			     (read-fare-csv          ; read csv file
			      (nth 1 (the exist-file-names)))))
   (exist-data-r1s (flatten                           ; remove bracket
		       (read-fare-csv          ; read csv file
			(nth 2 (the exist-file-names)))))
   (exist-data-r2s (flatten                           ; remove bracket
		      (read-fare-csv          ; read csv file
		       (nth 3 (the exist-file-names)))))
   (*exist-data-save (progn 
			 (write-fare-csv            ; save new data
			  (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the p1s)) ; array to list accuracy up to 1.0e-3
			  (nth 0 (the exist-file-names)))
			 (write-fare-csv            ; save new data
			  (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the p2s)) ; array to list accuracy up to 1.0e-3
			  (nth 1 (the exist-file-names)))
			 (write-fare-csv            ; save new data
			  (mapcar #'list (the r1s))           ; array to list
			  (nth 2 (the exist-file-names)))
			 (write-fare-csv            ; save new data
			  (mapcar #'list (the r2s))           ; array to list
			  (nth 3 (the exist-file-names)))))
   (new-file-names (list (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-p1s)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-p2s)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder)
					  (make-pathname 
					   :name (the file-name-r1s)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder)
					  (make-pathname 
					   :name (the file-name-r2s)
					   :type (the data-format)))))
   (*new-data-save (progn 
		     (write-fare-csv            ; save new data
		      (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the p1s)) ; array to list accuracy up to 1.0e-3
		      (nth 0 (the new-file-names)))
		     (write-fare-csv            ; save new data
		      (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the p2s)) ; array to list accuracy up to 1.0e-3
		      (nth 1 (the new-file-names)))
		     (write-fare-csv            ; save new data
		      (mapcar #'list (the r1s))           ; array to list
		      (nth 2 (the new-file-names)))
		     (write-fare-csv            ; save new data
		      (mapcar #'list (the r2s))           ; array to list
		      (nth 3 (the new-file-names)))))
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
   )
  :objects
  (                
   (handle-tangent-circles :type 'tangent-circles
			   :sequence (:size (length (the p1s)))
			   :p1 (nth (the-child index) (the p1s)) 
			   :p2 (nth (the-child index) (the p2s))
			   :r1 (nth (the-child index) (the r1s))
			   :r2 (nth (the-child index) (the r2s))
			   :hidden? t
			   )
  #+nil (handle-lofted :type 'lofted-surface
		  :curves (list-elements (the handle-tangent-circles) 
					 (the-element composed-curve))
		  )
   (handle-lofted :type 'loft-surfaces-with-curves
		  :all-curves (list-elements (the handle-tangent-circles) 
					     (the-element composed-curve))
		  :hidden? nil
		  )
   (handle-resursive :type 'resursive-joined-surfaces
		     :surface-main (first (list-elements (the handle-lofted lofe-with-two-curves) (the-element loft-section)))
		     :surface-rest (rest (list-elements (the handle-lofted lofe-with-two-curves) (the-element loft-section)))
		     :hidden? t
		     )
   (bottom-swept-solid :type 'extruded-solid
		       :distance 0.001
		       :profile (last (list-elements (the handle-resursive result-from-child v-iso-curves))) 
		       ;;(last (the handle-lofted curves))
		       :axis-vector (make-vector 0 0 -1) 
		       ) 
   )
  )


