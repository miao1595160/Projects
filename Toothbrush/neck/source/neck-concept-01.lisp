(in-package :E-Toothbrush)

(define-object neck-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv"     :settable) ; data-format
   
   (new-file "data-01/"   :settable) ; data folder name
   (exist-file "data-01/" :settable)
   
   (file-name-center "data-center") ; data file name
   (file-name-radius "data-radius")
   
   (centers (the exist-data-center) :settable)
   (radius  (the exist-data-radius) :settable)
   
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
					     :name (the file-name-center)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-radius)
					     :type (the data-format)))))
   (exist-data-center (mapcar #'apply-make-point                ; convert list to array
			(read-fare-csv          ; read csv file
			 (nth 0 (the exist-file-names)))))
   (exist-data-radius (flatten                                  ; remove the bracket
		 (read-fare-csv                 ; read csv file
		  (nth 1 (the exist-file-names)))))
  (*exist-data-save (progn (write-fare-csv           ; save current data
			     (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the centers)) ; array to list
			     (nth 0 (the exist-file-names)))
			    (write-fare-csv           ; save current data
			     (mapcar #'list                     ; add bracket
				     (the radius)) ;; all radius
			     (nth 1 (the exist-file-names)))))
   (new-file-names (list (merge-pathnames (the new-folder) 
					    (make-pathname 
					     :name (the file-name-center)
					     :type (the data-format)))
			   (merge-pathnames (the new-folder) 
					    (make-pathname 
					     :name (the file-name-radius)
					     :type (the data-format)))))
   (*new-data-save (progn (write-fare-csv           ; save current data
			     (mapcar #'(lambda (x) (array-to-list x *global-accuracy*)) (the centers)) ; array to list
			     (nth 0 (the new-file-names)))
			    (write-fare-csv           ; save current data
			     (mapcar #'list                     ; add bracket
				     (the radius)) ;; all radius
			     (nth 1 (the new-file-names)))))
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
   (volume (/ (getf (the circle-lofted brep precise-properties-plist) :volume) 1000))
   )
  :objects
  (            
   (circles :type 'arc-curve
	    :sequence (:size (length (the radius)))
	    :radius (nth (the-child index) (the radius))
	    :center (nth (the-child index) (the centers))
	    :hidden? t
	   ; :display-controls (list :color :red
           ;				    :line-thickness 2)
	    )
   (circle-lofted :type 'lofted-surface
		  :curves (list-elements (the circles))
		  )
   )
 )
