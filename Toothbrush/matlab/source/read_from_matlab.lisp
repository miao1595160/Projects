(in-package :matlab)

(defun get-head-angle ()
   (declare (special matlab-data)) 
   (declare (special first-element))
   (declare (special matlab2gdl))
   (with-open-stream (matlab (usocket:socket-stream 
			      (usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
     (evaluate "disp('Load model parameters')" matlab)
     (evaluate "run E_Toothbrush_P_01" matlab)
     (evaluate "disp('Open dynamic model')" matlab)
     (evaluate "open E_Toothbrush_01" matlab)
     (evaluate "disp('Start simulation')" matlab)
     (evaluate "sim E_Toothbrush_01" matlab)  
     (evaluate "disp('Close model')" matlab)
     (evaluate "close_system('E_Toothbrush_01')" matlab)
     (evaluate "head_angle = (max(simout_head_angle) - min(simout_head_angle))/2;" matlab)
     (setf matlab-data (read-matlab-file
			(prog1 (get-variables '("head_angle") matlab))))
     (disconnect matlab)
     )
   (setf first-element (first matlab-data))
   (setf matlab2gdl  
	 (loop for i from 0 below (array-total-size first-element) 
	    collect (row-major-aref first-element i)))
   )

(defun stop-matlab-sever()
  (with-open-stream (matlab (usocket:socket-stream 
			     (usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
    (disconnect matlab)))
  
(defun matlab-data-pre-process (matlab)
  (let*
      (
       (remove-bracket (first matlab)) ;; remove bracket
       (matlab2gdl (loop for i from 0 below (array-total-size remove-bracket) 
		      collect (row-major-aref remove-bracket i)))     ;; 2D Matrix to array
       (gdl-value (first matlab2gdl))
       )
    (print gdl-value)
    )
  )
 
(defun get-bar3-from-head-angle ()
  (let 
      (
       (matlab (usocket:socket-stream 
		(usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
       (matlab-head-angle 0)
       (matlab-bar3-x 0)
       (matlab-bar3-y 0)
       (head-angle 0)
       (bar3-x 0)
       (bar3-y 0)
       )
    (progn 
      (evaluate "disp('Load model parameters')" matlab)
      (evaluate "run E_Toothbrush_P_01" matlab)
      (evaluate "disp('Load simulation parameters')" matlab)
      (evaluate "run Case_get_bar3_from_head_angle" matlab)
      (setf matlab-head-angle (read-matlab-file
			 (prog1 (get-variables '("head_angle") matlab))))
      (setf head-angle (matlab-data-pre-process matlab-head-angle))
      (setf matlab-bar3-x (read-matlab-file
			 (prog1 (get-variables '("Bar3_x") matlab))))
      (setf bar3-x (matlab-data-pre-process matlab-bar3-x))
      (setf matlab-bar3-y (read-matlab-file
			 (prog1 (get-variables '("Bar3_y") matlab))))
      (setf bar3-y (matlab-data-pre-process matlab-bar3-y))
      )
    (disconnect matlab)
    (list head-angle bar3-x bar3-y)
  )
)

(defun AHP-motor ()
  (let 
      (
       (matlab (usocket:socket-stream 
		(usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
       (matlab-index nil)
       (index nil)
       )
    (progn 
      (evaluate "disp('start AHP for motor')" matlab)
      (evaluate "run AHP_motor" matlab)
      (setf matlab-index (read-matlab-file
			 (prog1 (get-variables '("index") matlab))))
      (setf index (matlab-data-pre-process matlab-index))
      )
    (disconnect matlab)
    (print index)
    )
  )
  
(defun dynamic-simulation ()
  (let 
      (
       (matlab (usocket:socket-stream 
		(usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
       )
    (progn 
      (evaluate "disp('start dynamic simulation of E-Toothbrush model')" matlab)
      (evaluate "run E_Toothbrush_P_01" matlab)
      (disconnect matlab)
      )
    )
  )

#+nil (defun automatic-design-for-head-angle ()
  (let 
      (
       (matlab (usocket:socket-stream 
		(usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))
     ;  (current 0)
       (matlab-head-angle 0)    ;;get matlab-head-angle
       (remove-bracket 0) ;; remove bracket
       (matlab2gdl 0)     ;; 2D Matrix to array
       (f 0)
       )
    (evaluate "a = 0" matlab)
    (loop
       (evaluate "a = a + 1" matlab)
       (setf matlab-head-angle (read-matlab-file
			  (prog1 (get-variables '("a") matlab))))
       (setf remove-bracket (first matlab-head-angle))
       (setf matlab2gdl  
	 (loop for i from 0 below (array-total-size remove-bracket) 
	    collect (row-major-aref remove-bracket i)))
       (setf f (first matlab2gdl))
       (when (>= f 10) (return f))
       )
       (disconnect matlab)
       (print f)
       )
  )
