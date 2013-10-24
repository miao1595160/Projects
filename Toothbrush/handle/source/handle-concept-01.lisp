(in-package :E-Toothbrush)

(define-object handle-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv" :settable)       ; data-format
   
   (new-file "data-01/"   :settable)
   (exist-file "data-01/" :settable)   ; data file name
  
   (file-name "data") ; data file name
   (data (the exist-data) :settable)

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

   (exist-file-name (merge-pathnames (the exist-folder) 
				     (make-pathname 
				      :name (the file-name)
				      :type (the data-format))))
   (exist-data (mapcar #'apply-make-point                ; convert list to array
		 (read-fare-csv          ; read csv file
		  (the exist-file-name))))
   (*exist-data-save (write-fare-csv            ; save current data
		      (mapcar #'array-to-list (the data)) ;; array to list
		      (the exist-file-name)))
   (new-file-name (merge-pathnames (the new-folder) 
				    (make-pathname 
				     :name (the file-name)
				     :type (the data-format))))
   (*new-data-save (write-fare-csv            ; save current data
		      (mapcar #'array-to-list (the data)) ;; array to list
		      (the new-file-name)))
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
   (handle-curve :type 'b-spline-curve
		 :control-points (the data)
	;	 :display-controls (list :color :green :line-thickness 2)
		 :hidden? t
		 )
   (handle-surface :type 'revolved-surface
		   :curve (the handle-curve))
   )
  )

