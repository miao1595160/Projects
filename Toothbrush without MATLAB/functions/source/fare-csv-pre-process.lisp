(in-package :E-Toothbrush)

;; Read csv file using fare-csv package
(defun read-fare-csv (path-name)
  (let 
      (
       (fare-csv:*separator* #\,)
       (read-result '())
       (container-outer '())
       (middle '())
       (elements '())
       )
      (setf read-result (fare-csv:read-csv-file path-name))
      (loop for i in read-result
	 do 
	   (let 
	       (
		(container-inner '())
		)  
	     (loop for j in i
		do 
		  (setf elements (ignore-errors (read-from-string j)))
		  (push elements container-inner) 
		  )
	     (setf middle (remove nil (reverse container-inner))))
	   (push middle container-outer))
	   (remove nil (reverse container-outer))))
;; test
;; (setf *data* (read-fare-csv "D:/data.csv"))

;; Write csv file using fare-csv package
(defun write-fare-csv (values path-name)
  (with-open-file 
      (output path-name :direction :output :if-exists :supersede) 
    (let ((fare-csv:*separator* #\,)) 
      (fare-csv:write-csv-lines values output))))
;; test
;; (write-fare-csv *data* "D:/data2.csv")
