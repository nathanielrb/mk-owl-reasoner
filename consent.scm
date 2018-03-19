(use posix matchable)

;; (use mini-kanren)
;; !!!
(change-directory "miniKanren-with-symbolic-constraints")
(load "mk-chicken.scm")
(change-directory "..")

(define (make-policy a b c d)
  `(ObjectIntersectionOf (ObjectSomeValuesFrom  spl:hasData ,a)
     (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasLocation ,b)
      (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasPurpose ,c)
         (ObjectSomeValuesFrom spl:hasProcessing ,d))))) ; (Storage s1 s2)


(load "definitions.scm")


(define (policyo P)
  (fresh (a b c d)
   (== P `(ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasData ,a)
             (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasLocation ,b)
               (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasPurpose ,c)
                (ObjectSomeValuesFrom spl:hasProcessing ,d))))))) ; (Storage s1 s2)

;; clean up (U (U (U ...)))
;; (define (simplify-policy P)



(define (subclasso a b #!optional (Implications Implications))

  (conde ((symbolo a) (symbolo b) (literal-subclasso a b))

         ;; ((symbolo a) (symbolo b) (== a b))

         ;; ((symbolo a) (symbolo b) 
         ;;  (fresh (q) (symbolo q) (subclasso a q) (subclasso q b)))

         ((== a 'spl:Null))

         ((fresh (pred x y)
             (== a `(ObjectSomeValuesFrom ,pred ,x))
             (== b `(ObjectSomeValuesFrom ,pred ,y))
             (subclasso x y)))

         ;; A∨B < C
         ;; constrain not A<B...
         ((fresh (q r)
          (== a `(ObjectUnionOf ,q ,r))
          (=/= q 'spl:Null)
          (=/= r 'spl:Null)
          (=/= q r)
          (subclasso q b)
          (subclasso r b)))

         ;; A < B∨C 
         ;; constrain not B<C...
         ((fresh (q r)
          (== b `(ObjectUnionOf ,q ,r))

          (=/= q 'spl:Null)
          (=/= r 'spl:Null)
          (=/= q r)
          ;;(project (a q r) (begin (print "UNION " a "\n" q "\n" r "\n\n") (== q q)))
          (conde ((subclasso a q))      ; correct?
                 ((subclasso a r))
                 ((fresh (x y)
                   (== a `(ObjectUnionOf ,x ,y))
                   (=/= x y)
                   (subclasso x q)
                   (subclasso y r))))))

         ;; A < B∧C
         ;; constrain not A<B...
         ((fresh (q r)
          (== b `(ObjectIntersectionOf ,q ,r))
          (=/= q r)
          ;; (=/= q 'spl:Null)
          ;; (=/= r 'spl:Null)
          (subclasso a q)
          (subclasso a r)))

         ;; A∧B < C 
         ((fresh (q r)
           (== a `(ObjectIntersectionOf ,q ,r))
          (=/= q r)
          ;;  (=/= q r)
          ;; (=/= q 'spl:Null)
          ;; (=/= r 'spl:Null)
           (fresh (b1 b2)
            (== b `(ObjectIntersectionOf ,b1 ,b2))
            (=/= b1 b2)
            (subclasso q b1)
            (subclasso r b2))))


	 ((fresh (q r remaining-implications)
	   ;;(implieso/literal q r Implications remaining-implications) ;; NOT CDR!!!!!!!
	   (rembero `(Implies ,q ,r) Implications remaining-implications)
	   (subclasso q b remaining-implications)
	   (subclasso a r remaining-implications)))

         ))  

(define (implieso/literal0 a b Implications remaining-implications)
  (rembero `(Implies ,a ,b) Implications remaining-implications))



(define (not-subclasso a b)
  (conde ((symbolo a) (symbolo b) (literal-not-subclasso a b))

         ;; ((symbolo a) (symbolo b) (== a b))

         ((== a 'spl:Null))

         ((fresh (pred x y)
             (== a `(ObjectSomeValuesFrom ,pred ,x))
             (== b `(ObjectSomeValuesFrom ,pred ,y))
             (not-subclasso x y)))

         ((fresh (q r)
           (== a `(ObjectIntersectionOf ,q ,r))
           (conde ((not-subclasso q b))
                  ((not-subclasso r b)))))

         ;; Union...
         ))

(define (print-policy P)
  (print
   (let rec ((P P) (n 0))
     (cond ((symbol? P) (format #f "~A" P))
           ((list? P) (format #f "~%~A~A~A" 
                              (string-tabulate (lambda (n) #\space) n)
                              (rec (car P) 0) (map (cut rec <> (+ n 1)) (cdr P))))))))

(define (print-policy-short P)
  (print
   (let rec ((P P) (n 0))
     (cond ((symbol? P) (format #f "~A" (case P
                                         ((ObjectIntersectionOf) "∧")
                                         ((ObjectUnionOf) "∨")
                                         ((ObjectSomeValuesFrom) "")
                                         (else P))))
           ((list? P) (let ((space (string-tabulate (lambda (n) #\space) n)))
                        (case (car P)
                          ((ObjectSomeValuesFrom) (format #f "~A<~A>"
                                                          space
                                                          (string-join (map (cut rec <> (+ n 1)) (cdr P)))))
                        ((ObjectIntersectionOf) (format #f "~%~A∧(~A)"
                                                        space
                                                        (string-join (map (cut rec <> (+ n 1)) (cdr P)))))
                        ((ObjectUnionOf) (format #f "~%~A∨(~A)"
                                                 space
                                                 (string-join (map (cut rec <> (+ n 1)) (cdr P)))))
                        ((Implies) (format #f "~%~A~A~%~A=>~A"
                                           space (rec (cadr P) (+ n 1))
                                           space  (rec (caddr P) (+ n 1)))))))
           ))))

(define pps print-policy-short)


;; (map print-policy-short (run 30 (P) (policyo P) (subclasso (make-policy '(ObjectUnionOf spl:PersonalData spl:LocationData) 'ex:Painting 'spl:archive) P)))

(load "examples.scm")
