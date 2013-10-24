(in-package :E-Toothbrush)

;; transform list of lists number from integer to float
;; used in nurbs-surface
(defun integer-to-float-lists (lists)
  (mapcar #'to-double-float lists))
;; repeat the second elements in the list 
;; used in E-toothbrush my-lofed-surface
(defun prepared-for-lofted (original)
  (let
      (
       (reorg ())
       (mid1 ())
       (mid2 ())
       (j 0)
       (i (length original))
       )
    (loop (when (>= j (- i 1)) (return))
       (setf mid1 (nth j original))
       (setf j (+ j 1))
       (setf mid2 (nth j original))
       (push (list mid1 mid2) reorg)
       )
    (reverse reorg)
    )
  )


