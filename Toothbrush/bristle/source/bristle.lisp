(in-package :E-Toothbrush)

(define-object bristle (base-object) 
  :input-slots 
  (
   (bristle-file-path "bristle/"   :settable)     ; main path
   (data-type "csv"                :settable)     ; data format

   (concept-path "data/concept01/" :settable) ; configuration 1
   (concept-file-name "data"       :settable) ; data file name
   )
  :computed-slots
  (
   (data-file-path  (merge-three-paths *path-name* (the bristle-file-path) (the concept-path))) ; generate the data path
   (based-curve (the head bristle-curve))
   (bristle-bounding-box (bounding-box-distance (the concept-01 base-projection bounding-box)))
   ;; weight [g]
   (weight (* (the concept-01 material-density)
	      (the concept-01 volume)))
   ;; cost [USD]
   (cost (* (the weight) 
	    (the concept-01 material-cost)))
   )
  :objects
  (
   (concept-01 :type 'bristle-concept-01
	       :path (the data-file-path)
	       :based-curve (the based-curve)
	       )
   )
  )

