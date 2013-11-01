(in-package :E-Toothbrush)

(define-object drive (base-object)
  :input-slots 
  (
   (drive-file-path "drive/"            :settable)  ; main path
   (data-type "csv"                     :settable)
   (concept-path "data/concept01/"      :settable)  ; configuration 1
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   ;; generate data path
   (data-file-path  (merge-three-paths *path-name* (the drive-file-path) (the concept-path)))
   ;; weight [g]
   (weight  (the concept-01 weight))
   ;; cost [USD]
   (cost (the concept-01 cost))
   )
  :objects
  (
   (concept-01 :type 'drive-concept-01
	       :path (the data-file-path)
	       )
   )
)

