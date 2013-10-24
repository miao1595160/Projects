;;
;; Copyright 2002-2012 Genworks International and Reinier van Dijk
;;
;; This source file is part of the General-purpose Declarative
;; Language project (GenDL).
;;
;; This source file contains free software: you can redistribute it
;; and/or modify it under the terms of the GNU Affero General Public
;; License as published by the Free Software Foundation, either
;; version 3 of the License, or (at your option) any later version.
;; 
;; This source file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; Affero General Public License for more details.
;; 
;; You should have received a copy of the GNU Affero General Public
;; License along with this source file.  If not, see
;; <http://www.gnu.org/licenses/>.
;;  
;; ######################
;; ## FILE DESCRIPTION ##
;; ######################
;;
;; author:      R.E.C. van Dijk (TU Delft)
;; version:     1
;; date:        Tuesday 12-06-2012 (DD-MM-YYYY) at 15:08:36
;;
;; DESCRIPTION:
;;
;; Projected curves object, fix for unexpected behavior in projected-curve, that tries to compose curves, but can not handle multiple projection results.
;; Optionally one can ask for a sorted result, viz. curve closest in distance from the reference point (curve-in bounding-bbox :center) is returned first,
;; then curves further away.

(in-package :surf)

(define-object projected-curves (base-object)
  :documentation
  (:author "R.E.C. van Dijk (TU Delft)"
   :date "Tuesday 12-06-2012 (DD-MM-YYYY) at 15:25:08"
   :version "1"
   :description "projected-curves object. Creates one or multiple 3D curves which are the result of projecting curve-in onto the surface according to the projection-vector. The resulting 3d-curve objects have an associated uv-curve which is typically useful for trimming. Look at the sequence of 3d-curve and uv-curve for the results of the projection operation. Optionally also 3d-curve-composed can be used, this curve tries to compose the final 3d-curve object into single curves. TODO: optionally one should be able to ask for sorted results, in which case the curve closest in absolute distance from the reference point (curve-in bounding-bbox :center) is returned first, then curves further away.")
  :input-slots
  ("GDL NURBS Curve. The curve to be projected to the surface."
   curve-in 
   
   "GDL NURBS Surface. The surface on which the <tt>curve-in</tt> is to be projected."
   surface 
   
   "3D Vector. The direction of projection."
   projection-vector

   ("Number or nil. The tolerance used when projecting and creating new curves.
Defaults to nil, which uses the default of the geometry kernel."
    approximation-tolerance nil)

   ("Number or nil. The angle tolerance used when projecting and creating new curves.
Defaults to nil, which uses the default of the geometry kernel."
    angle-tolerance-radians nil)
   
   #+nil("boolean. If t the curve closest in absolute distance from the reference point (curve-in bounding-bbox :center) is returned first, then curves further away. Default is nil."
    sorted? nil)

   )
  
  :computed-slots
  (#+nil(reference-point (the curve-in :bounding-bbox :center))
   (native-curves-uv (let ((projected-curves 
                            (project-curve *geometry-kernel* (the curve-in) 
                                           (the surface) (the projection-vector)
                                           (when (the approximation-tolerance)
                                             (the approximation-tolerance))
                                           (when (the angle-tolerance-radians)
                                             (the angle-tolerance-radians)))))
                       (mapcar #'(lambda(curve)
                                   (multiple-value-bind (control-points weights knots degree)
                                       (get-b-spline-curve*-data *geometry-kernel* curve)
                                     (make-b-spline-curve *geometry-kernel* control-points weights degree knots)))
                               projected-curves)))
   )  
  :objects
  (("GDL b-spline-curve. 3d curve, constructed for each uv-curve. Assocation (3d-curve 0) <-> (uv-curve 0), (3d-curve N) <-> (uv-curve N)."
    3d-curve :type 'b-spline-curve
	     :sequence (:size (the uv-curve :number-of-elements))
	     :knot-vector (the (uv-curve (the-child index)) knot-vector)
	     :weights (the (uv-curve (the-child index)) weights)
	     :degree (the (uv-curve (the-child index)) degree)
	     :control-points (mapcar #'(lambda(point)
					 (the surface (point (get-x point) (get-y point))))
				     (the (uv-curve (the-child index)) control-points))
	     :display-controls (list :color (case (the-child index)
					      (0 :red) (1 :green)
					      (otherwise :black))
				     :line-thickness 1))
   
  ("GDL UV curve object. The resultant projected-curve in the UV space of the surface."
    uv-curve :type 'curve
             :sequence (:size (the composed :curves :number-of-elements))
	     :native-curve (the composed (curves (the-child index)) :native-curve))
  
  ("GDL curve. Result of another composition step on 3D level. IMPORTANT: has NO uv-curve related to it."
    3d-curve-composed :type 'curve
                      :sequence (:size (the 3d-curves-composed :curves :number-of-elements))
		      :built-from (the 3d-curves-composed (curves (the-child index))))
  )   
  :hidden-objects
  (("GDL UV curve object. The resultant projected-curve in the UV space of the surface. IMPORTANT: these curves are segments and hence, not COMPOSED!."
    result-curve :type 'curve
                 :sequence (:size (length (the native-curves-uv)))
		 :native-curve (nth (the-child index) (the native-curves-uv)))
   
   ("GDL composed curve. The resultant projected-curve in the UV space of the surface, IMPORTANT: these curves are COMPOSED (from result-curve)!."
    composed :type 'composed-curves
             :curves-in (the result-curve :list-elements)
	     :distance-to-create-line 0.0)
   
   (3d-curves-composed :type 'composed-curves
		       :curves-in (the 3d-curve :list-elements))
   
   )
  )

(eval-when (compile load eval) (export 'projected-curves :surf))











