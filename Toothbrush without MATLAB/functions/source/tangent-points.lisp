(in-package :E-Toothbrush)

(defgeneric tangent-points (arc-1 arc-2)
  (:documentation "list-of-4-points. Returns the 4 points between which 2 linear curves can be drawn that touch exactly at the tangents of both circles. The first 2 points are the start and end points of curve #1 and the last two points the start and end points of curve #2."))
(defmethod tangent-points ((arc-1 arc) (arc-2 arc))
  (if (equal (the-object arc-1 :radius) (the-object arc-2 :radius))
      ;; if arc 1 and 2 have the same radius, it is easy.
      (let* ((o1o2 (3d-distance (the-object arc-1 :center) (the-object arc-2 :center)))
	     (o1t1x 0)
	     (o1t1y (the-object arc-1 :radius))
	     (o1t1x* o1t1x)
	     (o1t1y* (- o1t1y))
	     
	     (o2t2x o1o2)
	     (o2t2y (the-object arc-2 :radius))
	     (o2t2x* o2t2x)
	     (o2t2y* (- o2t2y))
	     
	     (vx (unitize-vector (subtract-vectors (the-object arc-2 :center) (the-object arc-1 :center)))) ; vectors
	     (vz (the-object arc-1 (face-normal-vector :top)))
	     (R (alignment :right vx :top vz))
	     (Rt (transpose-matrix R)))
	(list 
	 (add-vectors (matrix*vector Rt (make-vector o1t1x o1t1y 0)) (the-object arc-1 :center))
	 (add-vectors (matrix*vector Rt (make-vector o2t2x o2t2y 0)) (the-object arc-1 :center))
	 (add-vectors (matrix*vector Rt (make-vector o1t1x* o1t1y* 0)) (the-object arc-1 :center))
	 (add-vectors (matrix*vector Rt (make-vector o2t2x* o2t2y* 0)) (the-object arc-1 :center))
	 ))
      ;; if not, calculate the tangent points based on the intersection point and the triangular.
      (let ((o1o2 (3d-distance (the-object arc-1 :center) (the-object arc-2 :center))) ;  get the 3d distance between two arcs        
	    (r1 (the-object arc-1 :radius))
	    (r2 (the-object arc-2 :radius)))
	(let* ((vx (unitize-vector (subtract-vectors (the-object arc-2 :center) (the-object arc-1 :center)))) ; vectors
	       (vz (the-object arc-1 (face-normal-vector :top)))
	       (R (alignment :right vx :top vz))
	       (Rt (transpose-matrix R)))
	  (let ((o2o (/ (* o1o2 r2) (- r1 r2))))
	    (let((o2t2x (+ (/ (expt r2 2) o2o) o1o2))
		 (t2o (sqrt (- (expt o2o 2) (expt r2 2))))
		 (o1o (+ o1o2 o2o)))
	      (let ((o2t2y (/ (* t2o r2) o2o))
		    (o1t1x (/ (expt r1 2) o1o))
		    (t1o (sqrt (- (expt o1o 2) (expt r1 2)))))
		(let* ((o1t1y (/ (* t1o r1) o1o))
		       (o1t1x* o1t1x)
		       (o1t1y* (- o1t1y))
		       (o2t2x* o2t2x)
		       (o2t2y* (- o2t2y)))
		  (list 
		   (add-vectors (matrix*vector Rt (make-vector o1t1x o1t1y 0)) (the-object arc-1 :center))
		   (add-vectors (matrix*vector Rt (make-vector o2t2x o2t2y 0)) (the-object arc-1 :center))
		   (add-vectors (matrix*vector Rt (make-vector o1t1x* o1t1y* 0)) (the-object arc-1 :center))
		   (add-vectors (matrix*vector Rt (make-vector o2t2x* o2t2y* 0)) (the-object arc-1 :center))
		)))))))))
  
(excl:without-package-locks 
  (define-object-amendment geom-base:arc (geom-base::arcoid-mixin geom-base:base-object)

    :functions
    (("list-of-4-points. Returns the 4 points between which 2 linear curves can be drawn that touch exactly at the tangents of both circles. The first 2 points are the start and end points of curve #1 and the last two points the start and end points of curve #2. The other-arc should be of type 'arc."
      tangent-points
      (other-arc)
      (if (equal (the-object :radius) (the-object other-arc :radius))
	  (let* ((o1o2 (3d-distance (the-object :center) (the-object other-arc :center)))
		 (o1t1x 0)
		 (o1t1y (the-object :radius))
		 (o1t1x* o1t1x)
		 (o1t1y* (- o1t1y))
		 
		 (o2t2x o1o2)
		 (o2t2y (the-object other-arc :radius))
		 (o2t2x* o2t2x)
		 (o2t2y* (- o2t2y))
		 
		 (vx (unitize-vector (subtract-vectors (the-object other-arc :center) (the-object :center)))) ; vectors
		 (vz (the (face-normal-vector :top)))
		 (R (alignment :right vx :top vz))
		 (Rt (transpose-matrix R)))
	    (list 
	     (add-vectors (matrix*vector Rt (make-vector o1t1x o1t1y 0)) (the-object :center))
	     (add-vectors (matrix*vector Rt (make-vector o2t2x o2t2y 0)) (the-object :center))
	     (add-vectors (matrix*vector Rt (make-vector o1t1x* o1t1y* 0)) (the-object :center))
	     (add-vectors (matrix*vector Rt (make-vector o2t2x* o2t2y* 0)) (the-object :center))
	     ))
	  (let ((o1o2 (3d-distance (the-object other-arc :center) (the :center))) ;  get the 3d distance between two arcs        
		(r1 (the :radius))
		(r2 (the-object other-arc :radius)))
	    (let* ((vx (unitize-vector (subtract-vectors (the-object other-arc :center) (the :center)))) ; vectors
		   (vz (the (face-normal-vector :top)))
		   (R (alignment :right vx :top vz))
		   (Rt (transpose-matrix R)))
	      (let ((o2o (/ (* o1o2 r2) (- r1 r2))))
		(let((o2t2x (+ (/ (expt r2 2) o2o) o1o2))
		     (t2o (sqrt (- (expt o2o 2) (expt r2 2))))
		     (o1o (+ o1o2 o2o)))
		  (let ((o2t2y (/ (* t2o r2) o2o))
			(o1t1x (/ (expt r1 2) o1o))
			(t1o (sqrt (- (expt o1o 2) (expt r1 2)))))
		    (let* ((o1t1y (/ (* t1o r1) o1o))
			   (o1t1x* o1t1x)
			   (o1t1y* (- o1t1y))
			   (o2t2x* o2t2x)
			   (o2t2y* (- o2t2y)))
		      (list 
		       (add-vectors (matrix*vector Rt (make-vector o1t1x o1t1y 0)) (the :center))
		       (add-vectors (matrix*vector Rt (make-vector o2t2x o2t2y 0)) (the :center))
		       (add-vectors (matrix*vector Rt (make-vector o1t1x* o1t1y* 0)) (the :center))
		       (add-vectors (matrix*vector Rt (make-vector o2t2x* o2t2y* 0)) (the :center))
		       ))))))))))))

(define-object trimmed-closed-curve (curve)

  :documentation
  (:author 
   "Reinier van Dijk"
   :description 
   "Specialized trimmed-curve object for closed-curves. It allows to travel beyond the curve extreme.")

  :input-slots
  ("GDL Curve Object. The underlying curve from which to build this curve."
   curve-in

   ("Number. Specified start parameter. Defaults to the <tt>u1</tt> of the curve-in."
    u1-in (the curve-in u1))

   ("Number. Specified end parameter. Defaults to the <tt>u2</tt> of the curve-in."
    u2-in (the curve-in u2)))


  :computed-slots
  ((case (cond ((and (>= (the u2-in) (the u1-in))
                     (<= (the u2-in) (the curve-in :u-max))) :regular)
               ;; new cases
               ((> (the u2-in) (the curve-in :u-max))
                (if (> (- (the u2-in) (the curve-in :u-max))
                       (- (the u1-in) (the curve-in :u-min)))
                    (error "~&the u1->u2 range provided is larger than the range of a single revolution.~%")
                    :split-subtract-max))
               (t :split)))
   (no-of-trims (if (eq (the case) :regular) 1 2))
   (u1s (if (eq (the case) :regular)
            (list (the u1-in))
            (list (the u1-in) (the curve-in :u-min))))
   (u2s (case (the case)
          (:regular (list (the u2-in)))
          (:split (list (the curve-in u-max) (+ (the curve-in u-min) (the u2-in))))
          (:split-subtract-max (list (the curve-in :u-max) (+ (the curve-in :u-min) 
                                                              (- (the :u2-in) (the curve-in :u-max)))))))      

   (built-from (if (eq (the case) :regular) 
                   (the (trimmed-curves 0))
                   (the composed-curve))))


  :hidden-objects
  ((trimmed-curves :type 'trimmed-curve
                   :sequence (:size (the no-of-trims))
                   :built-from  (the curve-in)
                   :u1 (nth (the-child :index) (the u1s))
                   :u2 (nth (the-child :index) (the u2s)))
   (composed-curve :type 'composed-curve :curves (list-elements (the trimmed-curves)))))

#+nil(define-object trimmed-closed-curve (composed-curve)
;; old 
  :documentation
  (:author 
   "Reinier van Dijk"
   :description 
   "Specialized trimmed-curve object for closed-curves. It allows to travel beyond the curve extreme.")
  
  :input-slots
  ("GDL Curve Object. The underlying curve from which to build this curve."
   built-from
   
   ("Number. Specified start parameter. Defaults to the <tt>u1</tt> of the built-from."
    u1 (the built-from :u1))  
   
   ("Number. Specified end parameter. Defaults to the <tt>u2</tt> of the built-from."
    u2 (the built-from :u2))
   )
  
  :computed-slots
  ((case (cond ((and (>= (the u2) (the u1))
		     (<= (the u2) (the built-from :u-max))) :regular)
	       ;; new cases
	       ((> (the u2) (the built-from :u-max))
		(if (> (- (the u2) (the built-from :u-max))
		       (- (the u1) (the built-from :u-min)))
		    (error "the u1->u2 range provided is larger than the range of a single revolution.")
		    :split-subtract-max))
	       (t :split)))
   (no-of-trims (if (eq (the case) :regular) 1 2))
   (u1s (if (eq (the case) :regular)
	    (list (the u1))
	    (list (the u1) (the built-from :u-min))))
   (u2s (case (the case)
	  (:regular (list (the u2)))
	  (:split (list (the built-from :u-max) (+ (the built-from :u-min) (the :u2))))
	  (:split-subtract-max (list (the built-from :u-max) (+ (the built-from :u-min) (- (the :u2) (the built-from :u-max)))))))		
   (native-curve-iw (if (eq (the case) :regular) 
			(the (trimmed-curves 0) copy-new native-curve-iw)
			(the composed-curve copy-new native-curve-iw)))
   )
  
  :objects
  ((trimmed-curves :type 'trimmed-curve
		   :sequence (:size (the no-of-trims))
		   :pass-down (built-from)
		   :hidden? t
		   :u1 (nth (the-child :index) (the u1s))
		   :u2 (nth (the-child :index) (the u2s)))
   (composed-curve :type 'composed-curve :curves (list-elements (the trimmed-curves)))
   )
  )

#+nil (define-object two-circles (base-object)
  :input-slots
  (
   (p1 (make-vector 0 0 0) :settable)
   (p2 (make-vector 15 0 0) :settable)
   (r1 10 :settable)
   (r2 5 :settable)
   )
  :computed-slots
  (
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
	      :center (the p1)
	      :start-angle 0
	      :end-angle 2pi
	      :display-controls (list :color :blue :line-thickness 2)
	      :hidden? t
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
	      :center (the p2)
	      :start-angle 0
	      :end-angle 2pi
              :display-controls (list :color :red :line-thickness 2)
	      :hidden? t
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
		      :built-from (the circle-01)
		      :u1 (if (the reverse-1?) (the u1*) (the u1))
		      :u2 (if (the reverse-1?) (the u1) (the u1*))
		      :hidden? t
		      )
   (circle-trimmed-02 :type 'trimmed-closed-curve
		      :built-from (the circle-02)
		      :u1 (if (the reverse-2?) (the u2*) (the u2))
		      :u2 (if (the reverse-2?) (the u2) (the u2*))
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
