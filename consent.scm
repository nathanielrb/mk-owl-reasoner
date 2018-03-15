(use posix)

;; (use mini-kanren)
;; !!!
(change-directory "miniKanren-with-symbolic-constraints")
(load "mk-chicken.scm")
(change-directory "..")

(load "definitions.scm")

(define (membero a l)
  (fresh (x rest)
         (== l `(,x . ,rest)) 
         (conde ((== a x))
                ((membero a rest)))))

(define (policyo P)
  (fresh (a b c)
   (== P `(∧ (spl:hasData ,a)
             (∧ (spl:hasPurpose ,b)
                (spl:hasProcessing ,c)))))) ; (Storage s1 s2)

(define (make-policy a b c)
  `(∧ (spl:hasData ,a)
      (∧ (spl:hasPurpose ,b)
         (spl:hasProcessing ,c)))) ; (Storage s1 s2)

(define (subclasso a b)
  (conde ((fresh (pred subsets a1 b1)
                 (== a `(,pred ,a1))
                 (== b `(,pred ,b1))
                 (membero `(,pred ,subsets) types)
                 (membero `(,a1 ,b1) subsets)))

         ((fresh (q r)
           (=/= q r)
           (== a `(∨ ,q ,r))
           (subclasso q b)
           (subclasso r b))) ; + absento

         ;; ((fresh (q r)
         ;;   (=/= q r)
         ;;   (== b `(∨ ,q ,r))
         ;;   (subclasso q b)
         ;;   (subclasso r b)))

         ((fresh (q r s t)
           (=/= q r)
           (== a `(∧ ,q ,r))
           (== b `(∧ ,s ,t)) ; hmmm, this is real logic...
           (subclasso q s)
           (subclasso r t)))

         ((fresh (q r)
           (=/= q r)
           (== b `(∧ ,q ,r))
           (subclasso a q)
           (subclasso a r))) ;  + absento

         ((fresh (x)
           (subclasso a x)
           (subclasso x b)))

         ((== a b))))
         ))
         

