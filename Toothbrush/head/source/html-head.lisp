(in-package :E-Toothbrush)

(define-lens (html-format head) ()
  
  :output-functions
  ((model-inputs
    nil
    (html 
     (:p
      (:table
	  (:tr ((:td :bgcolor :yellow) "Head File Path")
	       (:td
		((:input :type :text :name :head-file-path :value
			 "head/"))))
	(:tr ((:td :bgcolor :yellow) "Concept File Path")
	     (:td
	      ((:input :type :text :name :concept-file-name :value
		       "data/concept01/"))))
	(:tr ((:td :bgcolor :yellow) "Concept File Name")
	     (:td
	      ((:input :type :text :name :concept-file-name :value
		       "data"))))
	(:tr ((:td :bgcolor :yellow) "Data Type")
	     (:td
	      ((:input :type :text :name :concept-file-name :value
		       "csv"))))
	)
      )
     (:p ((:input :type :submit :name :ok :value "OK")))))))
