(in-package :E-Toothbrush)

(define-object motor-load (base-object) 
  :input-slots 
  (
   (data)
   (motor-load (the data) :settable)
   )
  )

