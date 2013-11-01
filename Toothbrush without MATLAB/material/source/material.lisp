(in-package :E-Toothbrush)

(define-object material (base-object) 
  :input-slots 
  (
   )
  :objects
  (
   (plastic :type 'plastic
	    :display-controls (list :color :red)
	    )
   (duralumin :type 'duralumin
	      :display-controls (list :color :orange)
	    )
   )
  )

