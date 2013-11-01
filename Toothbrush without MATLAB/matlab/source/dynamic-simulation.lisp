(in-package :E-Toothbrush)

(define-object dynamic-simulation (base-object) 
  :input-slots 
  (
   (data-path)
   (data-name "Sim-configuration"  :settable)
   (data-format "csv"              :settable)
   (sim-time  3                    :settable)
   )
  :computed-slots
  (
   (exist-file (merge-pathnames (the data-path) 
				(make-pathname 
				 :name (the data-name)
				 :type (the data-format))))
   (simulation-file (merge-pathnames (the data-path) 
				(make-pathname 
				 :name 'matlab-simulation-results'
				 :type (the data-format)))) ;; create simulation result file name
   (*data-output (write-fare-csv            ; save current data
		      (mapcar #'list (list 
				      (the drive concept-01 bars four-bar-linkages-in-line crank-x)
				      (the drive concept-01 bars four-bar-linkages-in-line crank-y)
				      (the drive concept-01 bars four-bar-linkages-in-line rocker-x)
				      (the drive concept-01 bars four-bar-linkages-in-line rocker-y)
				      (the drive concept-01 gears motor-gear-radius)
				      (the drive concept-01 gears follow-gear-radius)
				      (the drive concept-01 bars dis-follow-gear-crank)
				      (the drive concept-01 bars drive-bar-length)
				      (the drive concept-01 load motor-load)
				      (+ 1 (the drive concept-01 motor motor-file-number))
				      (case (the head select)
					(1 1)
					(2 2)
					(otherwise 1))
				      (the drive concept-01 bars swing-angle)
				      (the sim-time)))
		      (the exist-file)))
   (new-folder? (if (not (search-file-in-path-list (the data-path) (the folder-list)))
		     (ensure-directories-exist (the data-path))                          ;; if it doesn't exist, create it.
		     (search-file-in-path-list (the data-path) (the folder-list))))
  #+nil (*start-simulation (matlab::dynamic-simulation)) ;; start simulation
   (*simulation-results (flatten (read-fare-csv     
				  (the simulation-file)))) ;; simulation results
   ;; head-angle 
   ;; swing-frequency
   ;; motor-speed
   ;; price
   ;; current
   ;; weight 
   )
  :objects
  (
   )
  )
