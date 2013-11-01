(in-package :E-Toothbrush)

(define-object drive-concept-01 (base-object) 
  :input-slots 
  (
   (path)
   (data-format "csv" :settable)           ; data-format
   
   (new-file "data-01/"   :settable)
   (exist-file "data-01/" :settable)    
  
   (file-name-bars    "data-bars")         ; data file name
   (file-name-gears   "data-gears")
   (file-name-motor   "data-motor")
   (file-name-battery "data-battery")
   (file-name-load    "data-load") 
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))

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
					     :name (the file-name-bars)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-gears)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-motor)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-battery)
					     :type (the data-format)))
			   (merge-pathnames (the exist-folder) 
					    (make-pathname 
					     :name (the file-name-load)
					     :type (the data-format)))))
   (exist-data-bars (flatten (read-fare-csv                      ; read csv file
			      (nth 0 (the exist-file-names)))))
   (exist-data-gears (flatten (read-fare-csv                     ; read csv file
			      (nth 1 (the exist-file-names)))))
   (exist-data-motor (flatten (read-fare-csv                     ; read csv file
			      (nth 2 (the exist-file-names)))))
   (exist-data-battery (flatten (read-fare-csv                   ; read csv file
			      (nth 3 (the exist-file-names)))))
   (exist-data-load (first (first (read-fare-csv                 ; read csv file
				   (nth 4 (the exist-file-names))))))
   (*exist-data-save (progn (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the bars swing-angle)
					   (the bars crank-length)
					   (the bars drive-bar-length)
					   (the bars dis-follow-gear-crank)))
				     (nth 0 (the exist-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the gears motor-gear-center-x)
					   (the gears motor-gear-center-y)
					   (the gears motor-gear-center-z)
					   (the gears motor-gear-radius)
					   (the gears motor-gear-height)
					   (the gears follow-gear-radius)))
			     (nth 1 (the exist-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the motor motor-file-number)
					   (the motor dis-motor-gear)))
			     (nth 2 (the exist-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the battery battery-radius)
					   (the battery battery-length)
					   (the battery battery-mass)
					   (the battery battery-capacity)
					   (the battery battery-cost)))
			     (nth 3 (the exist-file-names)))
			    (write-fare-csv                     ; save current data
			     (list (list (the load motor-load)))
			     (nth 4 (the exist-file-names)))))
   ;; new data save
   (new-file-names (list (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-bars)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-gears)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-motor)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-battery)
					   :type (the data-format)))
			 (merge-pathnames (the new-folder) 
					  (make-pathname 
					   :name (the file-name-load)
					   :type (the data-format)))))
   (*new-data-save (progn (write-fare-csv                       ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the bars swing-angle)
					   (the bars crank-length)
					   (the bars drive-bar-length)
					   (the bars dis-follow-gear-crank)))
				     (nth 0 (the new-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the gears motor-gear-center-x)
					   (the gears motor-gear-center-y)
					   (the gears motor-gear-center-z)
					   (the gears motor-gear-radius)
					   (the gears motor-gear-height)
					   (the gears follow-gear-radius)))
			     (nth 1 (the new-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the motor motor-file-number)
					   (the motor dis-motor-gear)))
			     (nth 2 (the new-file-names)))
			    (write-fare-csv                     ; save current data
			     (mapcar #'list                     ; add bracket
				     (list (the battery battery-radius)
					   (the battery battery-length)
					   (the battery battery-mass)
					   (the battery battery-capacity)
					   (the battery battery-cost)))
			     (nth 3 (the new-file-names)))
			    (write-fare-csv                     ; save current data
			     (list (list (the load motor-load)))
			     (nth 4 (the new-file-names)))))
   ;;  boundary of frame
   (bounding-box-for-frame (get-total-bounding-box (list (the bars crank bounding-box) 
							  (the bars rocker bounding-box)
							  (the bars coupler bounding-box) 
							  (the bars frame bounding-box) 
							  (the gears motor-gear bounding-box)
							  (the gears follow-gear bounding-box)
							  (the motor motor bounding-box)
							  (the battery battery bounding-box)
							  (the PCB PCB bounding-box))))
   ;; total weight [g]
   (weight (dot-prod (list (the bars volume)
			   (the gears volume)
			   1
			   1
			   (the PCB volume)
			   (the metal-frame volume)) ;; total volume [cm^3]
		     (list (the bars material-density)
			   (the gears material-density)
			   (first (last (the MATLAB dynamic-simulation *simulation-results))) ;; just the mass
			   (the battery battery-mass) ;; just the mass
			   (the PCB material-density)
			   (the metal-frame material-density)))) ;; density [g/cm^3]
   ;; total cost [USD]
   (cost (+ (* (the bars volume) (the bars material-density) (the bars material-cost))
	    (* (the gears volume) (the gears material-density) (the gears material-cost))
	    (nth 3 (the MATLAB dynamic-simulation *simulation-results))
	    (the battery battery-cost)
	    (* (the PCB volume) (the PCB material-density) (the PCB material-cost))
	    (* (the metal-frame volume) (the metal-frame material-density) (the metal-frame material-cost))))
   )
  :objects
  (                
   (bars :type 'bars
	 :data (the exist-data-bars)
	 :display-controls (list :color :red)
	 )
   (gears :type 'gears
	  :data (the exist-data-gears)
	  :display-controls (list :color :orange)
	  )
   (motor :type 'motor
	  :data (the exist-data-motor)
	  :exist-file-names (the exist-file-names)
	  :load (the load motor-load)
	  :display-controls (list :color :gold)
	  )
   (battery :type 'battery
	    :data (the exist-data-battery)
	    :display-controls (list :color :green)
	    )
   (PCB :type 'PCB
	:length (the battery battery-length)
	:width (* (the battery battery-radius) 2)
	:display-controls (list :color :cyan)
	)
   (metal-frame :type 'metal-frame
		:bounding-box-for-frame (the bounding-box-for-frame)
		:display-controls (list :color :blue)
		)
   (load :type 'motor-load
	 :data (the exist-data-load)
	 :display-controls (list :color :purple)
	 )
   
   )
  )

