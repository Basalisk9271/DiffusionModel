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
    (let (cube partition maxsize choice i j k l m n time ratio diffusion_coefficient room_dimension 
    speed_of_gas_molecules timestep distance_between_blocks dterm change sumval maxval minval)
    

    ; Set the array sizes so that they have memory


    (princ "What would you like maxsize to be: ") (finish-output)
    (setf maxsize (read))
    
    ; Create the cube and partition filled with zeroes
    (setf cube (make-array `(,maxsize ,maxsize ,maxsize) :initial-element 0.0l0))
    (setf partition (make-array `(,maxsize ,maxsize ,maxsize) :initial-element 0))
    (princ "Would you like a partition (y for 'yes' and n for 'no'): ") (finish-output)
    (if (string= (read) "Y")
        (progn
        
        (setf i (- (ceiling (* maxsize 0.5)) 1))
        (princ i)
        (loop for j from (- (ceiling (* maxsize 0.25) ) 1) to (- maxsize 1)
        do
          (loop for k from 0 to (- maxsize 1)
            do
            (setf (aref partition i j k) 1)
            )
        ))
    )

    ;print off the cubes
    ; (loop for i from 0 to (- maxsize 1)
    ;     do
    ;     (loop for j from 0 to (- maxsize 1)
    ;         do
    ;         (loop for k from 0 to (- maxsize 1)
    ;             do
    ;             (princ (aref partition i j k))
    ;         )
    ;         (terpri)
    ;     )
    ; (terpri)
    ; )

    (setf time 0.0)
    (setf ratio 0.0)
    (setf diffusion_coefficient 0.175)
    (setf room_dimension 5.0)
    (setf speed_of_gas_molecules 250.0) ; Based on 100 g/mol gas at RT
    (setf timestep (/ (/ room_dimension speed_of_gas_molecules) maxsize)) ; h in seconds
    (setf distance_between_blocks (/ room_dimension maxsize))
    (setf dterm (* diffusion_coefficient (/ timestep (* distance_between_blocks distance_between_blocks))))
    
    (setf (aref cube 0 0 0) 1E21)

    (loop 
        (loop for i from 0 to (- maxsize 1) 
            do (loop for j from 0 to (- maxsize 1) 
                do (loop for k from 0 to (- maxsize 1) 
                    do (loop for l from 0 to (- maxsize 1) 
                        do (loop for m from 0 to (- maxsize 1) 
                            do (loop for n from 0 to (- maxsize 1) 
                                do (if (and (or (and (= i l) (= j m) (= k (+ n 1))) 
                                             (or (and (= i l) (= j m) (= k (- n 1)))
                                             (or (and (= i l) (= j (+ m 1)) (= k n)) 
                                             (or (and (= i l) (= j (- m 1)) (= k n)) 
                                             (or (and (= i (+ l 1)) (= j m) (= k n)) 
                                             (and (= i (- l 1)) (= j m) (= k n))))))) (and (/= (aref partition i j k) 1) (/= (aref partition l m n) 1)))
                                (progn
                                    (setf change (* (- (aref cube i j k) (aref cube l m n)) dterm ))
                                    (setf (aref cube i j k) (- (aref cube i j k) change))
                                    (setf (aref cube l m n) (+ (aref cube l m n) change))
                                ); progn 
                                
                                )
                            )
                        )
                    )
                )
            )
        )

        (setf time (+ time timestep))
        
        (setf sumval 0.0)
        (setf maxval (aref cube 0 0 0))
        (setf minval (aref cube 0 0 0))
        
         (loop for i from 0 to (- maxsize 1) 
             do (loop for j from 0 to (- maxsize 1)
                 do (loop for k from 0 to (- maxsize 1) 
                     do (if (/= (aref partition i j k) 1)
                         (progn
                            (setf maxval (max (aref cube i j k ) maxval))
                            (setf minval (min (aref cube i j k ) minval ))
                            (setf sumval (+ sumval (aref cube i j k)))
                         ) ;progn
                     )
                 )    
             )
         )
        
        (setf ratio (/ minval maxval))

        (princ time)
        (princ " ")
        (princ ratio)
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
        

        (when (>= ratio 0.99)(return))
    )
    (princ "Box equilibrated in ")
    (princ time)
    (princ " seconds of simulated time.")
    (terpri)

))

