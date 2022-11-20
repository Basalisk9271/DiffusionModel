#!/usr/bin/sbcl --script

; Gabe Imlay
; CSC330: Organization of Programming Languages
; Project 1: Happy Numbers -> Lisp
; October 7th, 2022

; Tutorials Point is where I found most of my structure and how to call different things
; https://www.tutorialspoint.com/lisp/index.htm

; These are global arrays so that it can be seen by my bubbleSort function. 
; Josh gave me the idea to two arrays that will be manipulated the exact same by the bubble sort function
; He also found it was easiest to make the arrays global so it could be used from inside any function


;;; Here is the main program
(progn
    (defvar cube)
    (defvar partition)
    (defvar maxsize)
    (defvar choice)
    (defvar i)
    (defvar timevar)
    (defvar ratiovar)
    (defvar diffusion_coefficient)
    (defvar room_dimension)
    (defvar speed_of_gas_molecules)
    (defvar timestep)
    (defvar distance_between_blocks)
    (defvar DTerm)
    (defvar change)
    (defvar sumval)
    (defvar maxval)
    (defvar minval)

    ; Set the array sizes so that they have memory


    (princ "What would you like maxsize to be: ") (finish-output)
    (setf maxsize (read))
    
    ; Create the cube and partition filled with zeroes
    (setf cube (make-array `(,maxsize ,maxsize ,maxsize) :initial-element '(0.0l0)))
    (setf partition (make-array `(,maxsize ,maxsize ,maxsize) :initial-element '(0)))
    (princ "Would you like a partition (y for 'yes' and n for 'no'): ") (finish-output)
    (if (string= (read) "Y")
        (progn
        (setf i (ceiling (* maxsize 0.5)))
        (loop for j from  (ceiling (* maxsize 0.25)) to (- maxsize 1)
        do
          (princ "Test")
          (terpri)
          (loop for k from 0 to (- maxsize 1)
            do
            (setf (aref partition i j k) 1)
            )
        ))
    )

    ;print off the cubes
    (dotimes (i maxsize)
        (dotimes(j maxsize)
            (dotimes(k maxsize)
                (princ (aref partition i j k))
            )
            (terpri)
        )
    (terpri)
    )

    (setf timevar 0.0)
    (setf ratiovar 0.0)
    (setf diffusion_coefficient 0.175)
    (setf room_dimension 5.0)
    (setf speed_of_gas_molecules 250.0) ; Based on 100 g/mol gas at RT
    (setf timestep (/ (/ room_dimension speed_of_gas_molecules) maxsize)) ; h in seconds
    (setf distance_between_blocks (/ room_dimension maxsize))
    (setf dterm (* diffusion_coefficient (/ timestep (* distance_between_blocks distance_between_blocks))))
    
    (setf (aref cube 0 0 0) 1E21)

    (loop 
        (dotimes (i maxsize)
            (dotimes(j maxsize)
                (dotimes(k maxsize)
                    (dotimes (l maxsize)
                        (dotimes(m maxsize)
                            (dotimes(n maxsize)
                                if ((and (or (and (= i l) (= j m) (= k (+ n 1))) 
                                             (and (= i l) (= j m) (= k (- n 1)))
                                             (and (= i l) (= j (+ m 1)) (= k n)) 
                                             (and (= i l) (= j (- m 1)) (= k n)) 
                                             (and (= i (+ l 1)) (= j m) (= k n)) 
                                             (and (= i (- l 1)) (= j m) (= k n))) (and (/= (aref partition i j k) 1) (/= (aref partition i j k) 1)))
                                (progn
                                (setf change (* (- (aref cube i j k) (aref cube l m n)) dterm ))
                                (setf (aref cube i j k) (- (aref cube i j k) change))
                                (setf (aref cube l m n) (+ (aref cube l m n) change)))
                                )
                            )
                        )
                    )
                )
            )
        )

        (setf timevar (+ timevar timestep))
        
        (setf sumval 0.0)
        (setf maxval (aref cube 0 0 0))
        (setf minval (aref cube 0 0 0))
        
        (dotimes (i maxsize)
            (dotimes (j maxsize)
                (dotimes (k maxsize)
                    (if (/= (aref partition i j k) 1)
                        do
                        (setf maxval (max((aref cube i j k) maxval)))
                        (setf minval (min((aref cube i j k) minval)))
                        (setf sumval (+ sumval (aref cube i j k)))
                    )
                )    
            )
        )

        (setf ratiovar (/ minval maxval))

        (princ timevar)
        (princ " ")
        (princ ratiovar)
        (princ " ")
        (princ (aref cube 0 0 0))
        (princ " ")
        (princ (aref cube (- maxsize 1) 0 0))
        (princ " ")
        (princ (aref cube (- maxsize 1) (- maxsize 1) 0))
        (princ " ")
        (princ (aref cube (- maxsize 1) (- maxsize 1) (- maxsize 1)))
        (princ " ")
        (princ sumval)
        (terpri)
        

        (when (>= ratiovar 0.99)(return))
    )
    (princ "Box equilibrated in ")
    (princ timevar)
    (princ " seconds of simulated time.")

)

