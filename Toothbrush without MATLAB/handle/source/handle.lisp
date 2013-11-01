(in-package :E-Toothbrush)

(define-object handle (base-object) 
  :input-slots 
  (
   (handle-file-path "handle/"     :settable) ; main path
   (data-type "csv"                :settable)
   (concept-path "data/concept01/" :settable) ; configuration 1
   )
  :computed-slots
  (
   ;; generate data path
   (data-file-path  (merge-three-paths *path-name* (the handle-file-path) (the concept-path))) 
   (select (cond 
	     ((string= (the concept-path) "01" :start1 12 :end1 14) 1)
	     ((string= (the concept-path) "02" :start1 12 :end1 14) 2)
	     (t 1)))
   (handle-side-surface (case (the select)
			  (1 (the concept-01 handle-surface))
			  (2 (the concept-02 handle-resursive result-from-child))
			  (otherwise (the concept-01 handle-surface))))
   (handle-bounding-box (case (the select)
			  (1 (bounding-box-distance (the concept-01 bounding-box)))
			  (2 (bounding-box-distance (the concept-02 bounding-box)))
			  (otherwise (bounding-box-distance (the concept-01 bounding-box)))))
   (handle-surface-brep (case (the select)
			  (1 (the concept-01 handle-surface brep))
			  (2 (the concept-02 handle-resursive result-from-child brep))
			  (otherwise (the concept-01 handle-surface brep))))
   ;; volume [cm^3]
   (volume (/ (* (nth 0 (the handle-bounding-box))
		 (nth 1 (the handle-bounding-box))
		 (nth 2 (the handle-bounding-box))) 1000))
   ;; weight [g]
   (weight (* (case (the select)
		       (1 (the concept-01 material-density))
		       (2 (the concept-02 material-density))
		       (otherwise (the concept-01 material-density)))
	      (the volume)))
   ;; cost [USD]
   (cost (* (the weight) 
	    (case (the select)
	      (1 (the concept-01 material-cost))
	      (2 (the concept-02 material-cost))
	      (otherwise (the concept-01 material-cost)))))
   )
  :objects
  (
   (concept-01 :type 'handle-concept-01
	       :path (the data-file-path)
	       :hidden? (if (= (the select) 1)
			    nil
			    t)
	       )
   (concept-02 :type 'handle-concept-02
	       :path (the data-file-path)
	       :hidden? (if (= (the select) 2)
			    nil
			    t)
	       )
   )
)


