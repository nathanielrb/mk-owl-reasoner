(use posix matchable)

;; (use mini-kanren)
;; !!!
(change-directory "miniKanren-with-symbolic-constraints")
(load "mk-chicken.scm")
(change-directory "..")

(load "definitions.scm")

(define (policyo P)
  (fresh (a b c d)
   (== P `(ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasData ,a)
             (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasLocation ,b)
               (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasPurpose ,c)
                (ObjectSomeValuesFrom spl:hasProcessing ,d))))))) ; (Storage s1 s2)

;; clean up (U (U (U ...)))
;; (define (simplify-policy P)


(define (make-policy a b c d)
  `(ObjectIntersectionOf (ObjectSomeValuesFrom  spl:hasData ,a)
     (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasLocation ,b)
      (ObjectIntersectionOf (ObjectSomeValuesFrom spl:hasPurpose ,c)
         (ObjectSomeValuesFrom spl:hasProcessing ,d))))) ; (Storage s1 s2)

(define (subclasso a b)

  (conde ((symbolo a) (symbolo b) (literal-subclasso a b))

         ;; ((symbolo a) (symbolo b) (== a b))

         ;; ((symbolo a) (symbolo b) 
         ;;  (fresh (q) (symbolo q) (subclasso a q) (subclasso q b)))

         ((== a 'spl:Null))

         ((fresh (pred x y)
             (== a `(ObjectSomeValuesFrom ,pred ,x))
             (== b `(ObjectSomeValuesFrom ,pred ,y))
             (subclasso x y)))

;;          ((fresh (q r)
;;            (== b `(Implies ,q ,r))
;; (project (r) (begin (print "IMPLIES " r "\n\n") (== q q)))
;;            (subclasso a `(ObjectUnionOf ,r (Not ,q)))))

         ((fresh (q r)
           (== b `(Implies ,q ,r))
           (project (r) (begin (print "IMPLIES " r "\n\n") (== q q)))
           (subclasso a q)

         ((fresh (pred q)
           (== b `(Not (ObjectSomeValuesFrom ,pred ,q)))
(project (a q) (begin (print "NOT VALS:  " a " / " q "\n\n") (== q q)))
           (not-subclasso a `(ObjectSomeValues ,pred q))))

         ((fresh (q r)
           (== b `(Not (ObjectIntersectionOf ,q ,r)))
(project (q) (begin (print "NOT INT " q "\n\n") (== q q)))
           (subclasso a `(ObjectUnionOf (Not ,q) (Not ,r)))))

         ((fresh (q r)
           (== b `(Not (ObjectUnionOf ,q ,r)))
(project (q) (begin (print "NOT UNION" q "\n\n") (== q q)))
           (subclasso a `(ObjectIntersectionOf (Not ,q) (Not ,r)))))

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
          (project (a q r) (begin (print "UNION " a "\n" q "\n" r "\n\n") (== q q)))
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


         ))  

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

(define Belgian-Laws
  `(Implies ,(make-policy 'spl:LocationData 'svl:Be 'spl:Null 'spl:AnyProcessing)
            ,(make-policy 'spl:LocationData 'svl:Be 'spl:Marketing 'spl:AnyProcessing)))

(define User-Policy1 (make-policy '(ObjectUnionOf spl:LocationData spl:NavigationData) 
                                  'svl:EU
                                  'spl:Charity 'spl:AnyProcessing))

(define User-Policy2 (make-policy 'spl:LocationData 'svl:EU 'spl:Charity 'spl:aggregate))

(define ACME-Policy (make-policy 'spl:LocationData 'svl:BE
                                 'spl:Marketing 'spl:aggregate))

(define NICE-Policy (make-policy 'spl:LocationData 'svl:BE 'spl:Charity 'spl:aggregate))

;; (map print-policy-short (run 30 (P) (policyo P) (subclasso (make-policy '(ObjectUnionOf spl:PersonalData spl:LocationData) 'ex:Painting 'spl:archive) P)))
