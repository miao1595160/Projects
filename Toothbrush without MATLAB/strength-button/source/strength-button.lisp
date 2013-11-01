(in-package :E-Toothbrush)

(define-object strength-button (base-object) 
  :input-slots 
  (
   (strength-button-file-path "strength-button/" :settable)     ; main path
   (data-type "csv"          :settable)     ; data format

   (concept-path "data/concept01/" :settable) ; configuration 1
   (concept-file-name "data"       :settable) ; data file name
   )
  :computed-slots
  (
   (data-file-path  (merge-three-paths *path-name* (the strength-button-file-path) (the concept-path))) ; generate the data path
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
   (concept-01 :type 'button-concept-01
	       :based-surface (the based-surface)
	       :path (the data-file-path)
	       )
   
   )
  )

