(in-package :E-Toothbrush)

(defun dot-prod (a b)
  (reduce #'+ (map 'simple-vector #'* a b)))
