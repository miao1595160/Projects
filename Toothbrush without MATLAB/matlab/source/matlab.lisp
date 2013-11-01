(in-package :E-Toothbrush)

(define-object matlab (base-object) 
  :input-slots 
  (
   (matlab-path "matlab/model/" :settable)
   (data-folder "GDL data/"            :settable)
   )
  :computed-slots
  ( 
   (folder-list (cl-fad::list-directory 
		 (merge-pathnames (the matlab-path)  *path-name*))) ;; list of all data files
   (data-path (merge-three-paths *path-name* (the matlab-path) (the data-folder)))
   #+nil (*start-matlab (trivial-shell:shell-command "matlab -nosplash -nodesktop -r StartMatlabServer")
		  ;; (excl::run-shell-command "D:/Program Files/MATLAB/R2011b/bin/matlab.exe -r StartMatlabServer")
		  )
   #+nil (*stop-matlab (matlab::stop-matlab-sever))
   ;; (*sim-case-head-angle (first (matlab::get-head-angle)))
   )
  :objects
  (
   (dynamic-simulation :type 'dynamic-simulation
		       :data-path (the data-path)
		       )
   #+nil (sim-get-bar3-from-head-angle :type 'sim-get-bar3-from-head-angle
				       :matlab-data-folder (the exist-folder)
				       )
   )
  )
