(use srfi-69 srfi-13)

(define subclass-index (make-hash-table))
(define subclass-reverse-index (make-hash-table))

(define (subclass pair)
  (let ((a (car pair)) (b (cadr pair)))
    (hash-table-set! subclass-index a
                     (cons b (hash-table-ref/default subclass-index  a '())))
    (hash-table-set! subclass-reverse-index b
                     (cons a (hash-table-ref/default subclass-reverse-index b '())))))


(define (membero a l)
  (fresh (x rest)
         (== l `(,x . ,rest)) 
         (conde ((== a x))
                ((membero a rest)))))

(define (rembero a lst rst)
  (fresh (x rest)
   (== lst `(,x . ,rest)) 
   (conde ((== a x) (== rest rst))
	  ((fresh (rrst)
	    (== rst `(,x . ,rrst))
	    (rembero a rest rrst))))))

(define (literal-subclasso a b)
  (conde ((== a b))
         ((fresh (x y)
           (== a x) (== b y)
           (project (x y)
                   (cond ((and (symbol? x) (symbol? y))

                          (if (member y (hash-table-ref/default subclass-index x '()))
                              succeed
                              ;; fail))
                              (fresh (q)
                               (membero q (hash-table-ref/default subclass-index x '()))
                               (literal-subclasso q b))))
                                     
                         ((symbol? x) (let ((elts (hash-table-ref/default subclass-index x '())))
                                        (conde ((membero b elts))
                                               ((fresh (q)
                                                (membero q elts)
                                                (=/= q b)
                                                (literal-subclasso q b))))))
                         ((symbol? y) (let ((elts (hash-table-ref/default subclass-reverse-index y '())))
                                        (conde ((membero a elts))
                                               ((fresh (q)
                                                (membero q elts)
                                                (=/= q a)
                                                (literal-subclasso a q))))))   ))))))

;; (define (literal-not-subclasso a b)
;;   (conde ;((fresh (q) (symbolo q) (literal-subclasso a q) (literal-subclasso q b)))
;;          ((fresh (x y)
;;            (== a x) (== b y)
;;            (project (x y)
;;             (cond ((and (symbol? x) (symbol? y))
;;                    (if (member b (hash-table-ref/default subclass-index a '()))
;;                        fail
;;                        succeed))
;;                   ((symbol? x) (let rec ((elts (hash-table-ref/default subclass-index x '())))
;;                                  (if (null? rec) succeed
;;                                      (conde ((=/= b (car elts)))
;;                                             (rec (cdr elts))))))
;;                   ((symbol? y) (let rec ((elts (hash-table-ref/default subclass-reverse-index y '())))
;;                                  (if (null? rec) succeed
;;                                      (conde ((=/= a (car elts)))
;;                                             (rec (cdr elts))))))))))  ))

(define (literal-not-subclasso a b)
  (fresh (x y)
   (=/= a b)
   (== a x) (== b y)
   (project (x y)
    (cond ((and (symbol? x) (symbol? y))
           (if (member y (hash-table-ref/default subclass-index x '()))
               fail
               succeed))
          ((symbol? x) (let rec ((elts (hash-table-ref/default subclass-index x '())))
                         (if (null? elts) 
                             succeed
                             (conde ((=/= b (car elts))
                                     (rec (cdr elts)))))))
          ((symbol? y) (let rec ((elts (hash-table-ref/default subclass-reverse-index y '())))
                         (if (null? elts) 
                             succeed
                             (conde ((=/= a (car elts))
                                     (rec (cdr elts)))))))))))

(define subclasses
  '(;(spl:AnyRecipient top)
    (spl:ours spl:AnyRecipient)
    (spl:delivery spl:AnyRecipient)
    (spl:same  spl:AnyRecipient)
    (spl:other-recipient spl:AnyRecipient)
    (spl:unrelated spl:AnyRecipient)
    (spl:public spl:AnyRecipient)

    (svl:EU svl:World)
    (svl:EULike svl:World)
    (svl:ThirdCountries svl:World)
    (svl:BE svl:EU)

    ;; (spl:AnyPurpose top)
    (spl:Admin spl:AnyPurpose)
    
    (spl:AnyContact spl:AnyPurpose)
    (spl:Telemarketing spl:AnyContact)
    (spl:OtherContact spl:AnyContact)

    (spl:AuxPurpose spl:AnyPurpose)
    (spl:Account spl:AuxPurpose)
    (spl:Custom spl:AuxPurpose)
    (spl:Delivery spl:AuxPurpose)
    (spl:Feedback spl:AuxPurpose)
    (spl:Login spl:AuxPurpose)
    (spl:Marketing spl:AuxPurpose)
    (spl:Payment spl:AuxPurpose)
    (spl:State spl:AuxPurpose)

    (spl:Current spl:AnyPurpose)
    (spl:Arts spl:Current)
    (spl:Browsing spl:Current)
    (spl:Charity spl:Current)
    (spl:Community spl:Current)
    (spl:Downloads  spl:Current)
    (spl:Education spl:Current)
    (spl:Finmgt spl:Current)
    (spl:Gambling spl:Current)
    (spl:Gaming spl:Current)
    (spl:Government spl:Current)
    (spl:Health spl:Current)
    (spl:News spl:Current)
    (spl:Sales spl:Current)
    (spl:Search spl:Current)

    (ex:Painting spl:Arts)

    (spl:Develop spl:AnyPurpose)
    (spl:Historical spl:AnyPurpose)
    (spl:Tailoring spl:AnyPurpose)
    
    ;; data
    ;;(spl:AnyData top)
    (spl:PersonalData spl:AnyData)
    (spl:PseudonymizedData spl:AnyData)
    (spl:NavigationData spl:AnyData)
    (spl:LocationData spl:AnyData)
    
    ;; processing
    ;; (spl:AnyProcessing top)
    (spl:use spl:AnyProcessing)
    (spl:grantUse spl:AnyProcessing)
    (spl:acceptTracking spl:AnyProcessing)
    (spl:aggregate spl:AnyProcessing)
    (spl:anonymize spl:AnyProcessing)
    (spl:archive spl:AnyProcessing)
    (spl:copy spl:AnyProcessing)
    (spl:derive spl:AnyProcessing)
    (spl:digitize spl:AnyProcessing)
    (spl:distribute spl:AnyProcessing)
    (spl:give spl:AnyProcessing)
    (spl:move spl:AnyProcessing)
    (spl:read spl:AnyProcessing)
    (spl:secondaryUse spl:AnyProcessing)
    (spl:sell spl:AnyProcessing)
    (spl:transfer spl:AnyProcessing)
    (spl:share spl:AnyProcessing)))

(map subclass subclasses)

;; cheating!!

;; (define types `((spl:hasData ,datatypes)
;;                 (spl:hasPurpose ,purposes)
;;                 (spl:hasProcessing ,operations)))



(define Implications '())


;; (run 1 (q) (subclasso
;; 	    (make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:aggregate) 
;; 	    (make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:AnyProcessing)  ))
