(in-package :E-Toothbrush)

(define-object PCB (base-object) 
  :input-slots 
  (
   (length)
   (width)
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
   (volume (/ (getf (the PCB poly-brep brep precise-properties-plist) :volume) 1000))
   )
  :objects
  (
   (PCB-surface :type 'rectangular-surface
		:length (the battery battery-length)
		:width (* (the battery battery-radius) 2)
		:orientation (alignment 
			      :top (rotate-vector-d (the z-vector)
						    90
						    (the x-vector)))
		:center (translate (the battery battery center) 
				   :front (the battery battery-radius))
		:hidden? t
		)
   (PCB :type 'swept-solid
	:facial-brep (the PCB-surface brep)
	:distance 1
	:vector (make-vector 0 -1 0)
	:display-controls (list :color :turquoise-dark :transparency 0.3)
	)
   )
  )

