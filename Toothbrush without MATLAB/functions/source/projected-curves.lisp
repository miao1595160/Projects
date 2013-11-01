(in-package :E-Toothbrush)

(define-object projected-curves (projected-curve)

  :objects
  ((curves :type 'b-spline-curve
	   :sequence (:size (the uv-curves number-of-elements))
	   :knot-vector (the (uv-curves (the-child index)) knot-vector)
	   :weights (the (uv-curves (the-child index))  weights)
	   :degree (the (uv-curves (the-child index))  degree)
	   :display-controls (list :color (case (the-child index)
					    (0 :gold) (1 :blue)))
	   :control-points (mapcar #'(lambda(point)
				       (the surface (point (get-x point) (get-y point))))
				   (the (uv-curves (the-child index)) control-points))))
  
  :hidden-objects
  ((uv-curves :type 'curve
	      :sequence (:size (length (the native-curves-uv)))
	      :native-curve (nth (the-child index) (the native-curves-uv)))))

  
