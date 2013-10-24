(in-package :E-Toothbrush)

(define-object duralumin (base-object) 
  :input-slots 
  (
   (density 2.80 :settable) ;; duralumin [g/cm3]
   (cost 0.00267 :settable) ;; cost [USD/g]
   )
  )

