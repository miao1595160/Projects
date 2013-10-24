(in-package :E-Toothbrush)

(define-object motor-AHP (base-object) 
  :input-slots 
  (
   (diameter)
   (load)
   (requirment-cost (list 1 1 1) :settable)
   (requirment-use-time (list 0 1 1) :settable)
   (requirment-weight   (list 0 0 1) :settable)
   (file-name-requirement "AHP-motor-requirement" :settable)
   (file-name-constraint "AHP-motor-constraint"   :settable)
   (data-format "csv"                 :settable)
   )
  :computed-slots
  (
   (exist-file-requirement (merge-pathnames (the MATLAB data-path) 
					   (make-pathname 
					    :name (the file-name-requirement)
					    :type (the data-format))))
   (exist-file-constraint (merge-pathnames (the MATLAB data-path) 
					   (make-pathname 
					    :name (the file-name-constraint)
					    :type (the data-format))))
   (*data-output-requirement (write-fare-csv 
			      (list 
			       (the requirment-cost)
			       (the requirment-use-time)
			       (the requirment-weight))
			      (the exist-file-requirement)))
   (*data-output-constraint (write-fare-csv 
			     (mapcar #'list (list (the diameter)(the load)))
			     (the exist-file-constraint)))
   (*start-AHP-motor (matlab::AHP-motor))
   )
  )
