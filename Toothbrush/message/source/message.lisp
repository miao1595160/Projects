(in-package :E-Toothbrush)

(define-object message (base-object) 
  :computed-slots
  (
   ;; message requirment summary
   (*M1-constraint-requirement-summary (format nil "~{~{~A ~}~%~}" 
				   (mapcar #'list (list (the constraint requirement-target-user)
							(the constraint requirement-type-of-technology)
							(the constraint requirement-features)
							(the constraint requirement-remove-plaque)
							(the constraint requirement-hard-to-reach-areas)
							(the constraint requirement-weight)
							(the constraint requirement-working-time)
							(the constraint requirement-budget)))))
   ;; message constraint ergonomic summary
   (*M2-constraint-ergonomic-summary (format nil "~{~{~A ~}~%~}" 
					  (mapcar #'list (list (the constraint ergonomic-head-width)
							       (the constraint ergonomic-head-thickness)
							       (the constraint ergonomic-head-length)
							       
							       (the constraint ergonomic-bristle-width)
							       (the constraint ergonomic-bristle-thickness)
							       (the constraint ergonomic-bristle-length)
							       
							       (the constraint ergonomic-neck-width)
							       (the constraint ergonomic-neck-thickness)
							       (the constraint ergonomic-neck-length)
							       
							       (the constraint ergonomic-handle-width)
							       (the constraint ergonomic-handle-thickness)
							       (the constraint ergonomic-handle-length)))))
   ;; message constraint mechanical interference
   (*M2-constraint-interference-summary (format nil "~{~{~A ~}~%~}" 
					     (mapcar #'list (list
							     (the constraint interference-handle-metal-frame)
							     (the constraint interference-handle-follow-gear)
							     (the constraint interference-handle-battery)
							     (the constraint interference-handle-motor)))))
   (*M2-constraint-grashof-and-in-line (format nil "~{~{~A ~}~%~}"
					       (mapcar #'list (list
							       (the constraint grashof)
							       (the constraint in-line)))))
   ;; messange constraint simulation results
   (*M3-constraint-requirement-check (format nil "~{~{~A ~}~%~}" 
					     (mapcar #'list (list
							     (the constraint remove-plaque)
							     (the constraint sweep-angle)
							     (the constraint weight)
							     (the constraint use-time)
							     (the constraint cost)))))
   )
  )
