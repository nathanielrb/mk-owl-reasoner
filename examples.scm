(include "consent.scm")

(define Implications ; '())
  `((Implies ,(make-policy 'spl:LocationData 'svl:BE 'spl:Null 'spl:Null)
  	     ,(make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:AnyProcessing))))


(define User-Policy1 (make-policy '(ObjectUnionOf spl:LocationData spl:NavigationData) 
                                  'svl:EU
                                  'spl:Charity 'spl:AnyProcessing))

(define User-Policy2 (make-policy 'spl:LocationData 'svl:EU 'spl:Charity 'spl:aggregate))

(define ACME-Policy (make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:aggregate))

(define NICE-Policy (make-policy 'spl:LocationData 'svl:BE 'spl:Charity 'spl:aggregate))

;(map pps
;; (map pps (run 40 (P) (subclasso ACME-Policy P)))

(map pps (run 1 (x)
          (fresh (P Q)
           (== x `(ObjectUnionOf ,P ,Q))
           (policyo P)
          (policyo Q)
           (subclasso P `(ObjectSomeValuesFrom spl:hasLocation svl:EU))
;           (subclasso Q `(ObjectSomeValuesFrom spl:hasPurpose spl:Charity))
           (subclasso ACME-Policy x))))
