(in-package :E-Toothbrush)

(define-object head-tangent-circles (base-object)
  :input-slots
  (
   (center-01)
   (center-02)
   r1
   r2
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   
   (tangent-points (tangent-points (the circle-01) (the circle-02)))
   ; arc 1
   (u1 (get-parameter-of (the circle-01 (curve-intersection-point (the tegent-curve)))))
   (u1* (get-parameter-of (the circle-01 (curve-intersection-point (the tegent-curve*)))))
   (vector-test-1 (the circle-01 (tangent (the u1))))
   (reverse-1? (not (coincident-point? (the vector-test-1) (reverse-vector (the tegent-curve (tangent 0)))))) ;direction
   ; arc 2
   (u2 (get-parameter-of (the circle-02 (curve-intersection-point (the tegent-curve)))))   
   (u2* (get-parameter-of (the circle-02 (curve-intersection-point (the tegent-curve*)))))
   (vector-test-2 (the circle-02 (tangent (the u2))))
   (reverse-2? (not (coincident-point? (the vector-test-2) (the tegent-curve (tangent 0))))) ;direction
   )
  :objects
  (
   (circle-01 :type 'arc-curve
	      :radius (the r1)
	      :center (the center-01)
	      :start-angle 0
	      :end-angle 2pi
	      :display-controls (list :color :blue :line-thickness 2)
	      :hidden? t
	      :orientation (alignment 
				:top (rotate-vector-d (the z-vector)
						      -90
						      (the x-vector))
				)
	      )
   (circle-01-center :type 'point
		     :center (the circle-01 center)
		     :display-controls (list :color :blue)
		     )
   (tegent-point-01 :type 'point
		    :center (nth 0 (the tangent-points))
		    :display-controls (list :color :blue)
		    )
   (tegent-point-01* :type 'point
		     :center (nth 2 (the tangent-points))
		     :display-controls (list :color :blue)
		     )
   (tegent-curve :type 'linear-curve 
		 :start (the tegent-point-01 center)
		 :end   (the tegent-point-02 center)
		 :display-controls (list :color :purple :line-thickness 2)
 		 :hidden? t
		 )
   (circle-02 :type 'arc-curve
	      :radius (the r2)
	      :start-angle 0
	      :end-angle 2pi
	      :center (the center-02)
              :display-controls (list :color :red :line-thickness 2)
	      :hidden? t
	      :orientation (alignment 
			    :top (rotate-vector-d (the z-vector)
						  -90
						  (the x-vector))
			    )
	      )
   (circle-02-center :type 'point
		     :center (the circle-02 center)
		     :display-controls (list :color :red)
		     )
   (tegent-point-02 :type 'point
		    :center (nth 1 (the tangent-points))
		    :display-controls (list :color :red)
		    )
   (tegent-point-02* :type 'point
		     :center (nth 3 (the tangent-points))
		     :display-controls (list :color :red)
		     )
   (tegent-curve* :type 'linear-curve 
		  :start (the tegent-point-01* center)
		  :end   (the tegent-point-02* center)
		  :display-controls (list :color :orange :line-thickness 2)
		  :hidden? t
		  ) 
   (circle-trimmed-01 :type 'trimmed-closed-curve
		      :curve-in (the circle-01)
		      :u1-in (if (the reverse-1?) (the u1*) (the u1))
		      :u2-in (if (the reverse-1?) (the u1) (the u1*))
		      :hidden? t
		      )
   (circle-trimmed-02 :type 'trimmed-closed-curve
		      :curve-in (the circle-02)
		      :u1-in (if (the reverse-2?) (the u2*) (the u2))
		      :u2-in (if (the reverse-2?) (the u2) (the u2*))
		      :hidden? t
		      )
   (composed-curve :type 'composed-curve 
		   :curves (list (the tegent-curve)
				 (the circle-trimmed-01)
				 (the tegent-curve*)
				 (the circle-trimmed-02))
		   :display-controls (list :color :red :line-thickness 2)
		   ) 
   )
  )	  
