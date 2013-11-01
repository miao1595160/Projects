(in-package :E-Toothbrush)

(define-object assembly (base-object) 
  :input-slots 
  (
   (strings-for-display "E-Toothbrush")
   )
  :computed-slots
  (
   (*output-igs (with-format (iges (merge-pathnames *path-name* "E-Toothbrush.igs")) 
		  (write-the cad-output-tree)))
   (*output-stl (with-format (stl (merge-pathnames *path-name* "E-Toothbrush.stl")) 
		  (write-the cad-output-tree)))
   (*output-step (with-format (step (merge-pathnames *path-name* "E-Toothbrush.stp")
				     :assembly? t)
		   (write-the cad-output-tree)))
   (*output-vrml (with-format (vrml (merge-pathnames *path-name* "E-Toothbrush.wrl")) 
		   (write-the cad-output-tree)))
   (*output-native (with-format (native (merge-pathnames "E-Toothbrush.iwp" *path-name*)
					:assembly? t)
		     (write-the cad-output-tree)))
   (hidden-strength-button (cond 
			     ((string= (the interface 3-features) "standard") t)
			     ((string= (the interface 3-features) "medium") t)
			     ((string= (the interface 3-features) "hi-tech") nil)
			     (t t)))
   ;; total weight  
   (total-weight (+ (the head weight)
		    (the bristle weight)
		    (the neck weight)
		    (the handle weight)
		    (the power-button weight)
		    (the strength-button weight)
		    (the battery-display weight)
		    (the drive weight)))
   ;;total cost 
   (total-cost (+ (the head cost)
		  (the bristle cost)
		  (the neck cost)
		  (the handle cost)
		  (the power-button cost)
		  (the strength-button cost)
		  (the battery-display cost)
		  (the drive cost)))
   ;; use time
   (total-use-time (/ (the drive concept-01 battery battery-capacity) (nth 4 (the MATLAB dynamic-simulation *simulation-results))))
   )
  :objects
  (
   (interface :type 'interface
	      :display-controls (list :color :red)
	      )
   (head :type 'head
	 :display-controls (list :color :purple)
	 )
   (bristle :type 'bristle
	    :display-controls (list :color :grey)
	    )
   (neck :type 'neck
	 :display-controls (list :color :gold
				 :transparency 0.7)
	 )
   (handle :type 'handle
	   :display-controls (list :color :cyan
				   :transparency 0.7
				    :isos (list :n-u 8 :n-v 8))
	   )
   (power-button :type 'power-button
		 :display-controls (list :color :red)
		 )
   (strength-button :type 'strength-button
		    :hidden? (the hidden-strength-button)
		    :display-controls (list :color :green)
		    )
   (battery-display :type 'battery-display
		    :display-controls (list :color :blue)
		    )
   (drive :type 'drive
	  :display-controls (list :color :magenta)
	  )
   (material :type 'material
	     :display-controls (list :color :gold)
	     )
   (constraint :type 'constraint
	       :display-controls (list :color :green)
	       :total-weight (the total-weight)
	       :total-cost (the total-cost)
	       :total-use-time (the total-use-time)
	       )
   (MATLAB :type 'matlab
	   )
   (messages :type 'message
	     :display-controls (list :color :blue)
	     )
   )
  )
