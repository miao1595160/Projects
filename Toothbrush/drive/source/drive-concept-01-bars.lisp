(in-package :E-Toothbrush)

(define-object bars (base-object) 
  :input-slots 
  (
   (data)
   (swing-angle           (nth 0 (the data)) :settable)
   (crank-length          (nth 1 (the data)) :settable)
   (drive-bar-length      (nth 2 (the data)) :settable)
   (dis-follow-gear-crank (nth 3 (the data)) :settable)
   (select-material "plastic/duralumin" :settable)
   )
  :computed-slots
  (
   ;; Grashof and in-line condition
   (length-crank (3d-distance (the crank bar-start) (the crank bar-end)))
   (length-frame (3d-distance (the frame bar-start) (the frame bar-end)))
   (length-rocker (3d-distance (the rocker bar-start) (the rocker bar-end)))
   (length-coupler (3d-distance (the coupler bar-start) (the coupler bar-end)))
   ;; grashof condition
   (crank-smallest (loop for i in (list (the length-frame) (the length-rocker) (the length-coupler))
			do (if (> (the length-crank) i)
			       (return t) ;; crank is not the smallest
			       nil)))     ;; it's ok
   (frame-largest (loop for i in (list (the length-crank) (the length-rocker) (the length-coupler))
			do (if (< (the length-frame) i)
			       (return t) ;; frame is not the largest
			       nil)))     ;; it's ok
   ;; in-line condition 
   (in-line? (if (>= 0.01 
		     (abs (- (+ (expt (the length-crank) 2)
				(expt (the length-frame) 2))
			     (+ (expt (the length-rocker) 2)
				(expt (the length-coupler) 2)))))
		 t              ;; it's ok
		 nil))          ;; violated
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
   (volume (/ (+ (the length-crank)
		 (the length-frame)
		 (the length-rocker)
		 (the length-coupler)
		 (the drive-bar-length)
		 (the dis-follow-gear-crank)) 1000)) ;; bars are represented by lines which the areas are 1 [cm^3] 
	      
   )
  :objects
  (
   (drive-bar :type 'bar
	      :bar-start (the rocker bar-start) 
	      :bar-end (translate (the rocker bar-start) :up (the drive-bar-length))
	      :display-controls (list :color :gold-old :line-thickness 3)
	      )
   (four-bar-linkages-in-line :type 'four-bar-linkages-in-line
			      :rocker-center (the gears motor-gear (face-center :rear))
			      :rocker-angle (half (the swing-angle))
			      :dis-crank-rocker (+ (the gears motor-gear-radius) (the gears follow-gear-radius))
			      :crank-length (the crank-length)
			      :hidden? t
			      )
   (crank :type 'bar
	  :bar-start (translate (the gears follow-gear (face-center :rear)) 
				:up (the dis-follow-gear-crank))
	  :bar-end (translate (the gears follow-gear (face-center :rear))
			      :left (the four-bar-linkages-in-line crank-y)
			      :front (the four-bar-linkages-in-line crank-x)
			      :up (the dis-follow-gear-crank))
	  :display-controls (list :color :blue :line-thickness 3)
	  )
   (rocker :type 'bar
	   :bar-start (translate (the gears motor-gear (face-center :rear))
				 :up (the dis-follow-gear-crank))
	   :bar-end (translate (the gears motor-gear (face-center :rear))
			       :left (the four-bar-linkages-in-line rocker-y)
			       :front (the four-bar-linkages-in-line rocker-x)
			       :up (the dis-follow-gear-crank))
	   :display-controls (list :color :red :line-thickness 3)
	   )
   (coupler :type 'bar
	    :bar-start (the crank bar-end)
	    :bar-end (the rocker bar-end)
	    :display-controls (list :color :green :line-thickness 3)
	    )
   (frame :type 'bar
	      :bar-start (the crank bar-start)
	      :bar-end (the rocker bar-start)
	      :display-controls (list :color :maroon :line-thickness 3)
	      )
   (connection-bar :type 'bar
		   :bar-start (the gears follow-gear (face-center :rear)) 
		   :bar-end (translate (the-child bar-start) :up (the dis-follow-gear-crank))
		   :display-controls (list :color :orange :line-thickness 3)
		   ) 
   )
  )

