(in-package :E-Toothbrush)

(define-object battery-display (base-object) 
  :input-slots 
  (
   (battery-display-file-path "battery-display/" :settable)     ; main path
   (data-type "csv"          :settable)     ; data format

   ;; (concept-path "data/concept01/" :settable) ; configuration 1
   (concept-file-name "data"       :settable) ; data file name
   )
  :computed-slots
  (
   (concept-path (cond 
		   ((string= (the interface 3-features) "standard") (format nil "data/concept02/"))
		   ((string= (the interface 3-features) "medium") (format nil "data/concept01/"))
		   ((string= (the interface 3-features) "hi-tech") (format nil "data/concept01/"))
		   (t (format nil "data/concept01/"))))
   (data-file-path  (merge-three-paths *path-name* (the battery-display-file-path) (the concept-path))) ; generate the data path
   (select (cond 
	     ((string= (the concept-path) "01" :start1 12 :end1 14) 1)
	     ((string= (the concept-path) "02" :start1 12 :end1 14) 2)
	     (t 1)))
   (based-surface (the handle handle-side-surface))
   ;; weight [g]
   (weight (* (the concept-01 material-density)
	      (the concept-01 volume)))
   ;; cost [USD]
   (cost (* (the weight) 
	    (the concept-01 material-cost)))
   )
  :objects
  (
   (concept-01 :type 'battery-display-concept-01
	       :path (the data-file-path)
	       :based-surface (the based-surface)
	       :hidden? (if (= (the select) 1)
			    nil
			    t)
	       )
   (concept-02 :type 'battery-display-concept-02
	       :path (the data-file-path)
	       :based-surface (the based-surface)
	       :hidden? (if (= (the select) 2)
			    nil
			    t)
	       )
   
   )
  )

