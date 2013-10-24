(in-package :E-Toothbrush)

(define-object head (base-object) 
  :input-slots 
  (
   (head-file-path "head/" :settable) ; main path
   (data-type "csv"        :settable)

;; (concept-path "data/concept01/" :settable) ; configuration 1
   (concept-file-name "data"       :settable) ; data file name
   )
  :computed-slots
  (
   (concept-path (cond 
		   ((string= (the interface 2-type-of-technology) "oscillation") (format nil "data/concept01/"))
		   ((string= (the interface 2-type-of-technology) "sweep") (format nil "data/concept02/"))
		   (t (format nil "data/concept01/"))))
   (data-file-path (merge-three-paths *path-name* (the head-file-path) (the concept-path))) ; generate the data path
   (select (cond 
	     ((string= (the concept-path) "01" :start1 12 :end1 14) 1)
	     ((string= (the concept-path) "02" :start1 12 :end1 14) 2)
	     (t 1)))
   (bristle-curve (case (the select)
			  (1 (list
			      (nth  1  (list-elements (the concept-01 head-extruded edges)))))
			  (2 (list
			      (nth 4 (list-elements (the concept-02 head-extruded edges)))
			      (nth 5 (list-elements (the concept-02 head-extruded edges)))
			      (nth 6 (list-elements (the concept-02 head-extruded edges)))
			      (nth 7 (list-elements (the concept-02 head-extruded edges)))
			       ))
			  (otherwise 
			   (list
			      (nth  1  (list-elements (the concept-01 head-extruded edges)))))))
   (clearance-curve-surface (case (the select)
			      (1 (nth 1 (list-elements (the concept-01 motor-cylinder faces))))
			      (2 (nth 2 (list-elements (the concept-02 head-extruded faces))))
			      (otherwise (nth 1 (list-elements (the concept-01 motor-cylinder faces))))))
   (clearance-trimmed-island (case (the select)
			      (1 (the clearance-curve (3d-curve 1)))
			      (2 (the clearance-curve (3d-curve 0)))
			      (otherwise (the clearance-curve (3d-curve 1)))))
   (head-bounding-box (case (the select)
			(1 (list 
			    (nth 0 (bounding-box-distance (the concept-01 head-extruded bounding-box)))
			    (+ (nth 1 (bounding-box-distance (the concept-01 head-extruded bounding-box)))
			       (nth 1 (bounding-box-distance (the concept-01 motor-cylinder bounding-box))))
			    (nth 2 (bounding-box-distance (the concept-01 head-extruded bounding-box)))))
			(2 (list 
			    (nth 0 (bounding-box-distance (the concept-02 head-extruded bounding-box)))
			    (nth 1 (bounding-box-distance (the concept-02 head-extruded bounding-box)))
			    (nth 2 (bounding-box-distance (the concept-02 head-extruded bounding-box)))))
			(otherwise (list 
				    (nth 0 (bounding-box-distance (the concept-01 head-extruded bounding-box)))
				    (+ (nth 1 (bounding-box-distance (the concept-01 head-extruded bounding-box)))
				       (nth 1 (bounding-box-distance (the concept-01 motor-cylinder bounding-box))))
				    (nth 2 (bounding-box-distance (the concept-01 head-extruded bounding-box)))))))
   ;; weight [g]
   (weight (* (case (the select)
		       (1 (the concept-01 material-density))
		       (2 (the concept-02 material-density))
		       (otherwise (the concept-01 material-density)))
	      (case (the select)
		(1 (the concept-01 volume))
		(2 (the concept-02 volume))
		(otherwise (the concept-01 volume)))))
   ;; cost [USD]
   (cost (* (the weight) 
	    (case (the select)
	      (1 (the concept-01 material-cost))
	      (2 (the concept-02 material-cost))
	      (otherwise (the concept-01 material-cost)))))
   )
  :objects
  (
   (concept-01 :type 'head-concept-01
	       :path (the data-file-path)
	       :hidden? (if (= (the select) 1)
			    nil
			    t)
	       )
   (concept-02 :type 'head-concept-02
	       :path (the data-file-path)
	       :hidden? (if (= (the select) 2)
			    nil
			    t)
	       )
   (clearance-curve :type 'projected-curves
		    :curve-in (first (last (list-elements (the neck concept-01 circles)))) ; refer to the neck toppest circle
		    :surface (the clearance-curve-surface)  ; refer to the head circular surface
		    :projection-vector (make-vector 0 0 1)
		    :hidden? t
		    )
   (clearance-trimmed :type 'trimmed-surface
		      :island (the clearance-trimmed-island)
		      :basis-surface (the clearance-curve-surface)
		      :hidden? t
		      )
   (clearance-swept-solid :type 'swept-solid
			  :distance 2
			  :facial-brep (the clearance-trimmed brep)
			  :vector (make-vector 0 0 -1)
			  )
   #+nil(clearance-surface :type 'lofted-surface
		      :curves (list (first (last (list-elements (the neck concept-01 circles))))
				    (the clearance-curve (3d-curve 1)))
		      )
   )
  )

