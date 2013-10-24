(in-package :E-Toothbrush)
;; get total bounding box for two objects
(defun add-bounding-box(object-1 object-2)
  (let
      (
       (x1-ld (get-x (nth 0 object-1)))
       (y1-ld (get-y (nth 0 object-1)))
       (z1-ld (get-z (nth 0 object-1)))
       
       (x1-rt (get-x (nth 1 object-1)))
       (y1-rt (get-y (nth 1 object-1)))
       (z1-rt (get-z (nth 1 object-1)))
       
       (x2-ld (get-x (nth 0 object-2)))
       (y2-ld (get-y (nth 0 object-2)))
       (z2-ld (get-z (nth 0 object-2)))
       
       (x2-rt (get-x (nth 1 object-2)))
       (y2-rt (get-y (nth 1 object-2)))
       (z2-rt (get-z (nth 1 object-2)))
    
       (x-ld nil)
       (y-ld nil)
       (z-ld nil)
       
       (x-rt nil)
       (y-rt nil)
       (z-rt nil)
       )
    (setf x-ld (min x1-ld x2-ld))
    (setf y-ld (min y1-ld y2-ld))
    (setf z-ld (min z1-ld z2-ld))
    
    (setf x-rt (max x1-rt x2-rt))
    (setf y-rt (max y1-rt y2-rt))
    (setf z-rt (max z1-rt z2-rt))

    (list (make-vector x-ld y-ld z-ld)
	  (make-vector x-rt y-rt z-rt))
    )
  )
;; get total bounding box for a list of objects
(defun get-total-bounding-box (object-list)
  (let
      (
       (object-main (nth 0 object-list))
       (object-rest (rest object-list))
       (temp-result nil)
       (x-dis 0)
       (y-dis 0)
       (z-dis 0)
       (i 1)
       )
    (loop (when (>= i (length object-list)) (return))
       (setf temp-result (add-bounding-box object-main (nth 0 object-rest)))
       (setf object-main temp-result)
       (setf object-rest (rest object-rest))
       (incf i)
       )
    (setf x-dis (- (get-x (nth 1 temp-result)) (get-x (nth 0 temp-result))))
    (setf y-dis (- (get-y (nth 1 temp-result)) (get-y (nth 0 temp-result))))
    (setf z-dis (- (get-z (nth 1 temp-result)) (get-z (nth 0 temp-result))))
    (list temp-result x-dis y-dis z-dis)
    )
  )
	  
   
	      
	      


