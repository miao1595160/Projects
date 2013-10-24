(in-package :E-Toothbrush)

(define-object battery (base-object) 
  :input-slots 
  (
   (data)
   (battery-radius      (nth 0 (the data)) :settable) ;; [mm]
   (battery-length      (nth 1 (the data)) :settable) ;; [mm]
   (battery-mass        (nth 2 (the data)) :settable) ;; [g]
   (battery-capacity    (nth 3 (the data)) :settable) ;; [mAh]
   (battery-cost        (nth 4 (the data)) :settable) ;; [USD]
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   )
  :objects
  (
   (battery :type 'cylinder-solid 
	    :length (the battery-length)
	    :radius-1 (the battery-radius)
	    :radius-2 (the-child radius-1)
	    :orientation (alignment 
			  :top (rotate-vector-d (the z-vector)
						90
						(the x-vector)))
	    :display-controls (list :color :green)
	    :center  (translate (make-point 0 0 (get-z (nth 0 (the motor bounding-box))))
				:down (+ 2 (half (the-child length))))
	    )
   )
  )

