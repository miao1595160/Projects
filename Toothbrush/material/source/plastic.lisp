(in-package :E-Toothbrush)

(define-object plastic (base-object) 
  :input-slots 
  (
   (density 1.20 :settable) ;; Polyurethane [g/cm3]
   (cost 0.0019 :settable)  ;; cost [USD/g]
   )
  )

