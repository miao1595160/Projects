(in-package :E-Toothbrush)

(define-object sim-get-bar3-from-head-angle (base-object) 
  :input-slots 
  (
   (matlab-data-folder)
   (target-head-angle 30                 :settable)
   (bar3-increment 0.1                   :settable)
   (file-name "get-bar3-from-head-angle" :settable)
   (data-format "csv"                    :settable)
   )
  :computed-slots
  (
   (exist-file (merge-pathnames (the matlab-data-folder) 
				(make-pathname 
				 :name (the file-name)
				 :type (the data-format))))
   (*data-output (write-fare-csv            ; save current data
		      (mapcar #'list (list 
				      (the target-head-angle)
				      (the bar3-increment)))
		      (the exist-file)))
   (*start-simulation (matlab::get-bar3-from-head-angle))
			  
   )
  :functions
  (
   
   
   )
  )
  

