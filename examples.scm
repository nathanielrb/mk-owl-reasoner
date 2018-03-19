(define Implications ; '())
  `((Implies ,(make-policy 'spl:LocationData 'svl:BE 'spl:Null 'spl:Null)
  	     ,(make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:AnyProcessing))))


(define User-Policy1 (make-policy '(ObjectUnionOf spl:LocationData spl:NavigationData) 
                                  'svl:EU
                                  'spl:Charity 'spl:AnyProcessing))

(define User-Policy2 (make-policy 'spl:LocationData 'svl:EU 'spl:Charity 'spl:aggregate))

(define ACME-Policy (make-policy 'spl:LocationData 'svl:BE 'spl:Marketing 'spl:aggregate))

(define NICE-Policy (make-policy 'spl:LocationData 'svl:BE 'spl:Charity 'spl:aggregate))
