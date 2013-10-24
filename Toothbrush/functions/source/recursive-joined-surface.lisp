(in-package :E-Toothbrush)

(define-object resursive-joined-surfaces (base-object)

  :input-slots
  
  (surface-main
   surface-rest)

  :computed-slots
  ((result-from-child (if (equal 1 (length (the surface-rest))) (the joined-surfaces)
			  (the recursive-surfaces result-from-child))))
			  

  :objects
 (
  (joined-surfaces :type 'joined-surfaces
		   :surface (the surface-main)
		   :other-surface (first (the surface-rest))
		   )
  (recursive-surfaces :type (if (equal 1 (length (the surface-rest))) 'null-object  'resursive-joined-surfaces)
			     :surface-main (the joined-surfaces)
			     :surface-rest (rest (the surface-rest))
			     )
  )
 )
