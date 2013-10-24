(in-package :E-Toothbrush)

(define-object gears (base-object) 
  :input-slots 
  (
   (data)
   (motor-gear-center-x (nth 0 (the data)) :settable)
   (motor-gear-center-y (nth 1 (the data)) :settable)
   (motor-gear-center-z (nth 2 (the data)) :settable)
   (motor-gear-radius   (nth 3 (the data)) :settable)
   (motor-gear-height   (nth 4 (the data)) :settable)
   (follow-gear-radius  (nth 5 (the data)) :settable)
   (select-material "plastic/duralumin" :settable)
   )
  :computed-slots
  (
   (x-vector (make-vector 1 0 0))
   (y-vector (make-vector 0 1 0))
   (z-vector (make-vector 0 0 1))
   ;; density [g/cm^3]
   (material-density (cond 
		       ((string= (the select-material) "plastic") (the material plastic density))
		       ((string= (the select-material) "duralumin") (the material duralumin density))
		       (t (the material plastic density))))
   ;; cost [USD/g]
   (material-cost (cond 
		       ((string= (the select-material) "plastic") (the material plastic cost))
		       ((string= (the select-material) "duralumin") (the material duralumin cost))
		       (t (the material plastic cost))))
    ;; volume [cm^3]
   (volume (/ (+ (getf (the motor-gear poly-brep brep precise-properties-plist)  :volume)          ;; motor gear
		 (getf (the follow-gear poly-brep brep precise-properties-plist) :volume)) 1000))  ;; follow gear
   )
  :objects
  (
   (motor-gear :type 'cylinder-solid 
	       :length (the motor-gear-height)
	       :radius-1 (the motor-gear-radius)
	       :radius-2 (the-child radius-1)
	       :orientation (alignment 
			     :top (rotate-vector-d (the z-vector)
						   90
						   (the x-vector)))
	       :center (make-point (the motor-gear-center-x)
				   (the motor-gear-center-y)
				   (the motor-gear-center-z))
	       :display-controls (list :color :cyan)
	       )
   (follow-gear :type 'cylinder-solid 
		:length (the motor-gear length)
		:radius-1 (the follow-gear-radius)
		:radius-2 (the-child radius-1)
		:orientation (alignment 
			      :top (rotate-vector-d (the z-vector)
						    90
						    (the x-vector)))
		:center (translate (the motor-gear center) :rear (+ (the motor-gear-radius)
								     (the-child radius-1)))
		:display-controls (list :color :copper-cool)
		)
   )
  )

