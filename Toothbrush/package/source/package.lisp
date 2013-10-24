;;
;; Copyright 2002, 2009 Genworks International and Genworks BV 
;;
;; This source file is part of the General-purpose Declarative
;; Language project (GDL).
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
;; You should have received a copy of the G
;; NU Affero General Public
;; License along with this source file.  If not, see
;; <http://www.gnu.org/licenses/>.
;; 

;(in-package :gdl-user)

;(defpackage :E-Toothbrush)

(gdl:define-package :E-Toothbrush (:use :surf)
  (:nicknames :E-Toothbrush) (:export #:assembly))

(gwl:define-package :E-Toothbrush 
  ;  (:documentation #.(glisp:system-description :E-Toothbrush))
  (:nicknames :E-Toothbrush) 
  (:export #:assembly)
  (:use :surf))

(in-package :E-Toothbrush)

(defparameter *path-name* (merge-pathnames 
			   (pathname "Toothbrush\\") 
			   (merge-pathnames (pathname "Projects\\"))))

(defparameter *global-accuracy* 3) ; 0.001

(setf *output-units-default* :millimeters)


#+nil(defparameter *matlab* (usocket:socket-stream 
			     (usocket:socket-connect "localhost" 9999 :element-type '(unsigned-byte 8))))



