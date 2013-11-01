(in-package :E-Toothbrush)

(define-object interface (base-object) 
  :input-slots 
  (
   (1-target-user "adult/child"              :settable)
   (2-type-of-technology "oscillation/sweep" :settable)
   (3-features "standard/medium/hi-tech"     :settable)
   (4-remove-plaque "standard/medium/ultimate" :settable)
   (5-hard-to-reach-areas "standard/medium/premium" :settable)
   (6-weight 150 :settable)
   (7-working-time 2 :settable)
   (8-budget 30 :settable)
   
   )
  :computed-slots
  (
   )
  )

