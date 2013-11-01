;(in-package :gdl-user)
(in-package :E-Toothbrush)

(define-object loft-with-two-curves (base-object) 
  :input-slots 
  (
   (prepared-curves) 
   )
  :computed-slots
  (
   (curve-01 (nth 0 (the prepared-curves)))
   (curve-02 (nth 1 (the prepared-curves)))
   )
  :objects
  (                
   (loft-section :type 'lofted-surface
		 :curves (list (the curve-01)
			       (the curve-02))
		  )
   )
  )

(define-object loft-surfaces-with-curves (base-object) 
  :input-slots 
  (
   (all-curves)
   )
  :computed-slots
  (
   (prepared-curves (prepared-for-lofted (the all-curves)))
   )
  :objects
  (                
   (lofe-with-two-curves :type'loft-with-two-curves
			 :sequence (:size (length (the prepared-curves)))
			 :prepared-curves (nth (the-child index) (the prepared-curves))
			 :hidden? nil
			 )
   )
  )
