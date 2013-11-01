(in-package :E-Toothbrush)

(define-object metal-frame (base-object) 
  :input-slots 
  (
   (bounding-box-for-frame)
   (select-material "duralumin" :settable)
   )
  :computed-slots
  (
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
   (volume (/ (getf (the metal-frame brep precise-properties-plist) :volume) 1000))
   )
  :objects
  (
   (metal-frame-curve :type 'arc-curve
		      :sequence (:size 2)
		      :start-angle 0 
		      :end-angle 2pi
		      :radius (if (>= (nth 1 (the bounding-box-for-frame)) (nth 2 (the bounding-box-for-frame)))
				  (half (nth 1 (the bounding-box-for-frame)))
				  (half (nth 2 (the bounding-box-for-frame))))
		      :center (ecase (the-child index) 
				(0 (make-point 
				    0 
				    (half (+ (get-y (nth 0 (nth 0 (the bounding-box-for-frame))))
					     (get-y (nth 1 (nth 0 (the bounding-box-for-frame)))))) 
				    (get-z (nth 1 (nth 0 (the bounding-box-for-frame))))))
				(1 (make-point 
				    0 
				    (half (+ (get-y (nth 0 (nth 0 (the bounding-box-for-frame))))
					     (get-y (nth 1 (nth 0 (the bounding-box-for-frame)))))) 
				    (get-z (nth 0 (nth 0 (the bounding-box-for-frame)))))))
		      :hidden? t
		      )
   (metal-frame :type 'lofted-surface 
		:curves (list-elements (the metal-frame-curve)) 
		:display-controls (list :color :gray
					:transparency 0.8)
		:hidden? nil
		)
   )
  )

