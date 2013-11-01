(in-package :E-Toothbrush)

(define-object bar (base-object) 
  :input-slots 
  (
   bar-start
   bar-end
   )
  :computed-slots
  (
   )
  :objects
  (
   (bar :type 'linear-curve
	:start (the bar-start)
	:end (the bar-end)
	)   
   
   )
  )

