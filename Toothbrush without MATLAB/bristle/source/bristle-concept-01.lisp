(in-package :E-Toothbrush)

(define-object bristle-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (based-curve)

   (data-format "csv"     :settable) ; data-format
   
   (*new-file "data-01/"   :settable) ; data folder name
   (*exist-file "data-01/" :settable)
   
   (file-name "data" :settable)
   
   (offset (nth 0 (the exist-data)) :settable)
   (height (nth 1 (the exist-data)) :settable)

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
		      (mapcar #'list (list (the offset)
					   (the height)))
		      (the exist-file-name)))
   (new-file-name (merge-pathnames (the new-folder) 
				     (make-pathname 
				      :name (the file-name)
				      :type (the data-format))))

   (new-data (flatten                   ; remove bracket
		(read-fare-csv  ; read csv file
		 (the new-file-name))))
 
   (*new-data-save (write-fare-csv    ; save current data
		      (mapcar #'list (list (the offset)
					   (the height)))
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
   ;; volume [cm^3]
   (volume (/ (getf (the base-projection poly-brep brep precise-properties-plist) :volume) 1000))
   )
  :objects
  (
   (base-curve :type 'planar-offset-curve
	       :sequence (:size (length (the based-curve)))
	       :curve-in (nth (the-child index) (the based-curve))
	       :plane-normal (make-vector 0 1 0)
	       :distance (the offset)
	       :hidden? t
	       )	       
   (base-projection :type 'extruded-solid 
		    :profile (list-elements (the base-curve))
		    :distance (the height)
                    :axis-vector (make-vector 0 -1 0)
		    )
   )
  )
