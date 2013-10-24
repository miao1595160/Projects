;;(in-package :gdl-user)
(in-package :E-Toothbrush)
(define-object four-bar-linkages-in-line (base-object)
  :input-slots
  (
   (rocker-center)
   (rocker-angle)
   (dis-crank-rocker)
   (crank-length)
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   ;; crank center
   (crank-center (get-3d-point-of (the rocker-circle (curve-intersection-point (the rocker-reference-line)))))
   ;; get the angle between the crank and frame
   (vector-rocker-crank (subtract-vectors (the rocker-point center) (the crank-point center)))
   (vector-rocker-bar-far-crank (subtract-vectors (the rocker-bar-far end) (the crank-point center)))
   (angle-crank-frame (angle-between-vectors-d (the vector-rocker-crank) (the vector-rocker-bar-far-crank)))
   ;; crank x y
   (crank-x (* (cos (degrees-to-radians (the angle-crank-frame))) (the crank-length)))
   (crank-y (* (sin (degrees-to-radians (the angle-crank-frame))) (the crank-length)))
   ;; rocker x y
   (rocker-x (* (sin (degrees-to-radians (- (the rocker-angle) (the angle-crank-frame)))) 
		   (the rocker-length)))
   (rocker-y (* (cos (degrees-to-radians (abs (- (the rocker-angle) (the angle-crank-frame))))) 
		   (the rocker-length)))
   (rocker-length (/ (the crank-length) (sin (degrees-to-radians (the rocker-angle)))))
   )
  :objects
  (
   (rocker-point :type 'point
		 :display-controls (list :color :red :thickness 2)
		 :center (the rocker-center)
		 )
   (rocker-bar-near :type 'linear-curve 
		    :start (the rocker-point center)
		    :end (make-point 
			  (+ (* (sin (degrees-to-radians (the rocker-angle))) (the rocker-length))
			     (get-x (the rocker-point center)))
			  (* (cos (degrees-to-radians (the rocker-angle))) (the rocker-length))
			  (get-z (the rocker-point center)))
		    :display-controls (list :color :blue :thickness 1)
		    )
   (rocker-bar-far :type 'linear-curve 
		    :start (the rocker-point center)
		    :end (make-point 
			  (+ (* (sin (degrees-to-radians (the rocker-angle))) (the rocker-length) -1)
			     (get-x (the rocker-point center)))
			  (* (cos (degrees-to-radians (the rocker-angle))) (the rocker-length))
			  (get-z (the rocker-point center)))
		    :display-controls (list :color :green :thickness 1)
		    )
   (rocker-reference-line :type 'linear-curve
			  :start (the rocker-bar-far end)
			  :end (translate (the rocker-bar-near end) :right (the dis-crank-rocker))
			  )
   (rocker-circle :type 'arc-curve
		  :radius (the dis-crank-rocker)
		  :center (the rocker-center)
		  :start-angle 0
		  :end-angle 2pi
		  )
   (crank-point :type 'point
		:center (the crank-center)
		:display-controls (list :color :purple :thickness 2)
		)
   (frame :type 'linear-curve
	  :start (the crank-point center)
	  :end   (the rocker-point center)
	  :display-controls (list :thickness 2)
	  )
   )
  )

  
