(in-package :E-Toothbrush)

(define-object constraint (base-object) 
  :input-slots 
  (
   (head-width-threshold (nth 0 (the exist-data-head)) :settable)
   (head-thickness-threshold (nth 1 (the exist-data-head)) :settable)
   (head-length-threshold (nth 2 (the exist-data-head))    :settable)
   
   (bristle-width-threshold (nth 0 (the exist-data-bristle))     :settable)
   (bristle-thickness-threshold (nth 1 (the exist-data-bristle)) :settable)
   (bristle-length-threshold (nth 2 (the exist-data-bristle))    :settable)
   
   (neck-width-threshold (nth 0 (the exist-data-neck))     :settable)
   (neck-thickness-threshold (nth 1 (the exist-data-neck)) :settable)
   (neck-length-threshold (nth 2 (the exist-data-neck))    :settable)
   
   (handle-width-threshold (nth 0 (the exist-data-handle))     :settable)
   (handle-thickness-threshold (nth 1 (the exist-data-handle)) :settable)
   (handle-length-threshold (nth 2 (the exist-data-handle))    :settable)

   (*constraint-file-path "constraint/data/" :settable)
   (*data-format     "csv"                   :settable)
   ;; (*exist-file-path "data-01/"           :settable)
   (*new-file-path   "data-01/"              :settable)

   (*threshold-head    "data-head"    :settable)
   (*threshold-bristle "data-bristle" :settable)
   (*threshold-neck    "data-neck"    :settable)
   (*threshold-handle  "data-handle"  :settable)
   
   (total-weight)
   (total-cost)
   (total-use-time)
   )
  :computed-slots
  (
   ;; requirement
   ;; constraint handle/head diameter and length, neck length 
   (requirement-target-user (cond 
					 ((string= (the interface 1-target-user) "adult") (format nil "The target user is an adult. Constraints - Ergonomics can be found in standard XX1.")) 
					 ((string= (the interface 1-target-user) "child") (format nil "The target user is a child. Constraints - Ergonomics can be found in standard XX2."))
					 (t (format nil "The target user is an adult. Ergonamic requirments can be found in standard XX1."))))
   ;; type of head
   (requirement-type-of-technology (cond 
						((string= (the interface 2-type-of-technology) "oscillation") (format nil "The brush head will be oscillated."))
						((string= (the interface 2-type-of-technology) "sweep") (format nil "The brush head will be swept."))
						(t (format nil "The brush head will be oscillated."))))
   ;; customized button; battery display
   (requirement-features (cond 
				      ((string= (the interface 3-features) "standard") (format nil "Simplified battery display."))
				      ((string= (the interface 3-features) "medium") (format nil "Detailed battery display."))
				      ((string= (the interface 3-features) "hi-tech") (format nil "Detailed battery display; With customized mode."))
				      (t (format nil "Simplified battery display."))))
   ;; constraint motor speed/load
   (requirement-remove-plaque (cond 
					   ((string= (the interface 4-remove-plaque) "standard") (format nil "Removes up to 97% of plaque. (The working frequency of brush head is larger than 3Hz when the load is no more than 1 mNm)."))
					   ((string= (the interface 4-remove-plaque) "medium") (format nil "Removes up to 98% of plaque. (The working frequency of brush head is larger than 4Hz when the load is no more than 2 mNm)"))
					   ((string= (the interface 4-remove-plaque) "ultimate") (format nil "Removes up to 99.7% of plaque. (The working frequency of brush head is larger than 5Hz when the load is no more than 3 mNm)"))
					   (t (format nil "Removes up to 97% of plaque. (The working frequency of brush head is larger than 3Hz when the load is no more than 1 mNm)."))))
   ;; constraint sweep angle
   (requirement-hard-to-reach-areas (cond 
						 ((string= (the interface 5-hard-to-reach-areas) "standard") (format nil "Covers up to 97% of hard-to-reach areas. (The sweep angle of brush head should be larger than 30 degrees)."))
						 ((string= (the interface 5-hard-to-reach-areas) "medium")   (format nil "Covers up to 99% of hard-to-reach areas. (The sweep angle of brush head should be larger than 35 degrees)."))
						 ((string= (the interface 5-hard-to-reach-areas) "premium")  (format nil "Covers all areas. (The sweep angle of brush head should be larger than 40 degrees)."))
						 (t (format nil "Covers up to 97% of hard-to-reach areas. (The sweep angle of brush head should be larger than 30 degrees)."))))
   ;; constraint weight
   (requirement-weight (format nil "The weight should be limited in ~D gram." (the interface 6-weight)))
   ;; constraint working time
   (requirement-working-time (format nil "The working time should be longer than ~D hours." (the interface 7-working-time)))
   ;; constraint budget
   (requirement-budget (format nil "The budget should be limited in ~D USD." (the interface 8-budget)))
   
   ;; ergonomic
   (*exist-file-path (cond 
		       ((string= (the interface 1-target-user) "adult") (format nil "data-01/")) 
		       ((string= (the interface 1-target-user) "child") (format nil "data-02/"))
		       (t (format nil "data-01/"))))
   (ergonomic-standard (cond 
			 ((string= (the interface 1-target-user) "adult") (format nil "XX1")) 
			 ((string= (the interface 1-target-user) "child") (format nil "XX2"))
			 (t (format nil "XX1"))))
   (*folder-list (cl-fad::list-directory 
		  (merge-pathnames (the *constraint-file-path)  *path-name*))) ;; list of all data files
   (exist-folder (merge-three-paths *path-name* (the *constraint-file-path) (the *exist-file-path)))
   (new-folder (merge-three-paths *path-name* (the *constraint-file-path) (the *new-file-path)))
   (*new-folder? (if (not (search-file-in-path-list (the new-folder) (the *folder-list)))
		     (ensure-directories-exist (the new-folder))                          ;; if it doesn't exist, create it.
		     (search-file-in-path-list (the exist-folder) (the *folder-list)))) ;; if exist, use it.
   
   (exist-file-head (merge-pathnames (the exist-folder) 
			       (make-pathname 
				:name (the *threshold-head)
				:type (the *data-format))))
   (exist-file-bristle (merge-pathnames (the exist-folder) 
				  (make-pathname 
				   :name (the *threshold-bristle)
				   :type (the *data-format))))
   (exist-file-neck (merge-pathnames (the exist-folder) 
			       (make-pathname 
				   :name (the *threshold-neck)
				   :type (the *data-format))))
   (exist-file-handle (merge-pathnames (the exist-folder) 
				  (make-pathname 
				   :name (the *threshold-handle)
				   :type (the *data-format))))
   (exist-data-head (flatten (read-fare-csv             ; read csv file
			      (the exist-file-head))))
   (exist-data-bristle (flatten (read-fare-csv          ; read csv file
			      (the exist-file-bristle))))
   (exist-data-neck (flatten (read-fare-csv             ; read csv file
			      (the exist-file-neck))))
   (exist-data-handle (flatten (read-fare-csv          ; read csv file
				(the exist-file-handle))))
   (*exist-data-save (progn (write-fare-csv            ; save current data
			     (mapcar #'list (list 
					     (the head-width-threshold)
					     (the head-thickness-threshold)
					     (the head-length-threshold))) ;; array to list
			     (the exist-file-head))
			    (write-fare-csv            ; save current data
			     (mapcar #'list (list 
					     (the bristle-width-threshold)
					     (the bristle-thickness-threshold)
					     (the bristle-length-threshold))) ;; array to list
			     (the exist-file-bristle))
			    (write-fare-csv            ; save current data
			     (mapcar #'list (list 
					     (the neck-width-threshold)
					     (the neck-thickness-threshold)
					     (the neck-length-threshold))) ;; array to list
			     (the exist-file-neck))
			    (write-fare-csv            ; save current data
			     (mapcar #'list (list 
					     (the handle-width-threshold)
					     (the handle-thickness-threshold)
					     (the handle-length-threshold))) ;; array to list
			     (the exist-file-handle))))
   (new-file-head (merge-pathnames (the new-folder) 
				   (make-pathname 
				    :name (the *threshold-head)
				    :type (the *data-format))))
   (new-file-bristle (merge-pathnames (the new-folder) 
				      (make-pathname 
				       :name (the *threshold-bristle)
				       :type (the *data-format))))
   (new-file-neck (merge-pathnames (the new-folder) 
				   (make-pathname 
				    :name (the *threshold-neck)
				    :type (the *data-format))))
   (new-file-handle (merge-pathnames (the new-folder) 
				     (make-pathname 
				      :name (the *threshold-handle)
				      :type (the *data-format))))
   (*new-data-save (progn (write-fare-csv            ; save current data
			   (mapcar #'list (list 
					   (the head-width-threshold)
					   (the head-thickness-threshold)
					   (the head-length-threshold))) ;; array to list
			   (the new-file-head))
			  (write-fare-csv            ; save current data
			   (mapcar #'list (list 
					   (the bristle-width-threshold)
					   (the bristle-thickness-threshold)
					   (the bristle-length-threshold))) ;; array to list
			   (the new-file-bristle))
			  (write-fare-csv            ; save current data
			   (mapcar #'list (list 
					   (the neck-width-threshold)
					   (the neck-thickness-threshold)
					   (the neck-length-threshold))) ;; array to list
			   (the new-file-neck))
			  (write-fare-csv            ; save current data
			   (mapcar #'list (list 
					   (the handle-width-threshold)
					   (the handle-thickness-threshold)
					   (the handle-length-threshold))) ;; array to list
			   (the new-file-handle))))

   (ergonomic-head-width (if (or (>= (nth 0 (the head head-bounding-box)) (the head-width-threshold)) 
			  (<= (nth 0 (the head head-bounding-box)) 5))
		      (format nil "Due to the ergonomic standard ~D, the width of head should be limited between 5 and ~D mm." (the ergonomic-standard) (the head-width-threshold))
		      (format nil "")))
   (ergonomic-head-thickness (if (or (>= (nth 1 (the head head-bounding-box)) (the head-thickness-threshold))
			      (<= (nth 1 (the head head-bounding-box)) 1))
			  (format nil "Due to the ergonomic standard ~D, the thickness of head should be limited between 1 and ~D mm." (the ergonomic-standard) (the head-thickness-threshold))
			  (format nil "")))
   (ergonomic-head-length (if (or (>= (nth 2 (the head head-bounding-box)) (the head-length-threshold))
			   (<= (nth 2 (the head head-bounding-box)) 5))
		       (format nil "Due to the ergonomic standard ~D, the length of head should be limited between 5 and ~D mm." (the ergonomic-standard) (the head-length-threshold))
		       (format nil "")))
   
   (ergonomic-bristle-width (if (or (>= (nth 0 (the bristle bristle-bounding-box)) (the bristle-width-threshold)) 
			  (<= (nth 0 (the bristle bristle-bounding-box)) 5))
		       (format nil "Due to the ergonomic standard ~D, the width of bristle should be limited between 5 and ~D mm." (the ergonomic-standard) (the bristle-width-threshold))
		       (format nil "")))
   (ergonomic-bristle-thickness (if (or (>= (nth 1 (the bristle bristle-bounding-box)) (the bristle-thickness-threshold))
			      (<= (nth 1 (the bristle bristle-bounding-box)) 1))
			  (format nil "Due to the ergonomic standard ~D, the thickness of bristle should be limited between 1 and ~D mm." (the ergonomic-standard) (the bristle-thickness-threshold))
			  (format nil "")))
   (ergonomic-bristle-length (if (or (>= (nth 2 (the bristle bristle-bounding-box)) (the bristle-length-threshold))
			   (<= (nth 2 (the bristle bristle-bounding-box)) 5))
		       (format nil "Due to the ergonomic standard ~D, the length of bristle should be limited between 5 and ~D mm." (the ergonomic-standard) (the bristle-length-threshold))
		       (format nil "")))
   (ergonomic-neck-width (if (or (>= (nth 0 (the neck neck-bounding-box)) (the neck-width-threshold)) 
			  (<= (nth 0 (the neck neck-bounding-box)) 5))
		      (format nil "Due to the ergonomic standard ~D, the width of neck should be limited between 5 and ~D mm." (the ergonomic-standard) (the neck-width-threshold))
		      (format nil "")))
   (ergonomic-neck-thickness (if (or (>= (nth 1 (the neck neck-bounding-box)) (the neck-thickness-threshold))
			      (<= (nth 1 (the neck neck-bounding-box)) 5))
			  (format nil "Due to the ergonomic standard ~D, the thickness of neck should be limited between 5 and ~D mm." (the ergonomic-standard) (the neck-thickness-threshold))
			  (format nil "")))
   (ergonomic-neck-length (if (or (>= (nth 2 (the neck neck-bounding-box)) (the neck-length-threshold))
			   (<= (nth 2 (the neck neck-bounding-box)) 40))
		       (format nil "Due to the ergonomic standard ~D, the length of neck should be limited between 40 and ~D mm." (the ergonomic-standard) (the neck-length-threshold))
		       (format nil "")))
   (ergonomic-handle-width (if (or (>= (nth 0 (the handle handle-bounding-box)) (the handle-width-threshold)) 
			  (<= (nth 0 (the handle handle-bounding-box)) 10))
		       (format nil "Due to the ergonomic standard ~D, the width of handle should be limited between 10 and ~D mm." (the ergonomic-standard) (the handle-width-threshold))
		       (format nil "")))
   (ergonomic-handle-thickness (if (or (>= (nth 1 (the handle handle-bounding-box)) (the handle-thickness-threshold))
			      (<= (nth 1 (the handle handle-bounding-box)) 10))
			  (format nil "Due to the ergonomic standard ~D, the thickness of handle should be limited between 10 and ~D mm." (the ergonomic-standard) (the handle-thickness-threshold))
			  (format nil "")))
   (ergonomic-handle-length (if (or (>= (nth 2 (the handle handle-bounding-box)) (the handle-length-threshold))
			   (<= (nth 2 (the handle handle-bounding-box)) 100))
		       (format nil "Due to the ergonomic standard ~D, the length of handle should be limited between 100 and ~D mm." (the ergonomic-standard) (the handle-length-threshold))
		       (format nil "")))
   ;; interference
   (interference-handle-metal-frame (if (the handle handle-surface-brep (brep-intersect? (the drive concept-01 metal-frame metal-frame brep)))
					(format nil "There is an interference between handle and metal frame. You can enlarge the size of the handle or reduce the size of the components inside the metal frame.")
					(format nil "")))
   (interference-handle-follow-gear (if (loop for j in 
						  (loop for i in (list-elements (the drive concept-01 gears follow-gear face-breps) )
						     collect (the handle handle-surface-brep (brep-intersect? i)))
						do (if (equal j t)
						       (return t)))
					(format nil "There is an interference between handle and follow gear. You can enlarge the size of the handle or reduce the size of the follow gear.")
					(format nil "")))
   (interference-handle-battery     (if  (loop for j in 
						  (loop for i in (list-elements (the drive concept-01 battery battery face-breps) )
						     collect (the handle handle-surface-brep (brep-intersect? i)))
						do (if (equal j t)
						       (return t)))
					(format nil "There is an interference between handle and battery. You can enlarge the size of the handle or reduce the size of the battery.")
					(format nil "")))
   (interference-handle-motor       (if (loop for j in 
						  (loop for i in (list-elements (the drive concept-01 motor motor face-breps))
						     collect (the handle handle-surface-brep (brep-intersect? i)))
						do (if (equal j t)
						       (return t)))
					(format nil "There is an interference between handle and motor. You can enlarge the size of the handle or reduce the size of the motor.")
					(format nil "")))
   ;; grashof condition for drive bars
   (grashof (if (the drive concept-01 bars crank-smallest)
			  (format nil "The grashof condition cannot be satisfied for the drive bars, because the crank is not the smallest.")
			  (if (the drive concept-01 bars frame-largest)
			      (format nil "The grashof condition cannot be satisfied for the drive bars, because the frame is not the largest.")
			      (if (> (+ (the drive concept-01 bars length-crank) (the drive concept-01 bars length-frame))
				     (+ (the drive concept-01 bars length-rocker) (the drive concept-01 bars length-coupler)))
				  (format nil "The grashof condition cannot be satisfied for the drive bars, because the sum of crank and frame is larger than the sum of rocker and coupler.")
				       (format nil "")))))
   ;; in-line condtion for drive bars
   (in-line (if (the drive concept-01 bars in-line?)
			  (format nil "")
			  (format nil "The in-line condition for bars cannot be satisfied. Try to change the swing angle or the length of crank.")))
   ;; remove plaque
   (remove-plaque-required (cond 
			    ((string= (the interface 4-remove-plaque) "standard") 3)
			    ((string= (the interface 4-remove-plaque) "medium")   4)
			    ((string= (the interface 4-remove-plaque) "ultimate") 5)
			    (t 3)))
   (remove-plaque (if (> (nth 1 (the MATLAB dynamic-simulation *simulation-results)) (the remove-plaque-required))
				(format nil "")
				(format nil "The working frequency of the brush head is ~D Hz, which is lower than the required frequency ~D Hz." (round (nth 1 (the MATLAB dynamic-simulation *simulation-results))) (the remove-plaque-required))))
   ;; sweep angle
   (sweep-angle-required (cond 
			   ((string= (the interface 5-hard-to-reach-areas) "standard") 30)
			   ((string= (the interface 5-hard-to-reach-areas) "medium")   35)
			   ((string= (the interface 5-hard-to-reach-areas) "premium")  40)
			   (t 30)))
   (sweep-angle (if (> (nth 0 (the MATLAB dynamic-simulation *simulation-results)) (the sweep-angle-required))
		      (format nil "")
		      (format nil "The sweep angle of the brush head is ~D degrees, which is lower than the required angle ~D degrees." (round (nth 0 (the MATLAB dynamic-simulation *simulation-results))) (the sweep-angle-required))))
   ;; weight
   (weight (if (< (the total-weight) (the interface 6-weight))
	       (format nil "")
	       (format nil "The total weight of the toothbrush is ~D g, which is overweight by ~D g according to the requirement." (round (the total-weight)) (round (- (the total-weight) (the interface 6-weight))))))
   ;; use time
   (use-time (if (> (the total-use-time) (the interface 7-working-time))
		 (format nil "")
		 (format nil "The total use-time of the toothbrush is ~D h, which is less than ~D h according to the requirement." (round (the total-use-time)) (round (- (the interface 7-working-time) (the total-use-time))))))
   ;; cost
   (cost (if (< (the total-cost) (the interface 8-budget))
	     (format nil "")
	     (format nil "The total cost of the toothbrush is ~D USD, which is over by ~D USD according to the requirement." (round (the total-cost)) (round (- (the total-cost) (the interface 8-budget))))))
   )
  )

