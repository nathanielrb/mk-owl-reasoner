	 ;;          ((fresh (q r)
	 ;;            (== b `(Implies ,q ,r))
	 ;; (project (r) (begin (print "IMPLIES " r "\n\n") (== q q)))
	 ;;            (subclasso a `(ObjectUnionOf ,r (Not ,q)))))

	 ;;          ((fresh (q r)
	 ;;            (== b `(Implies ,q ,r))
	 ;;            (project (r) (begin (print "IMPLIES " r "\n\n") (== q q)))
	 ;;            (subclasso a q)

	 ;;          ((fresh (pred q)
	 ;;            (== b `(Not (ObjectSomeValuesFrom ,pred ,q)))
	 ;; (project (a q) (begin (print "NOT VALS:  " a " / " q "\n\n") (== q q)))
	 ;;            (not-subclasso a `(ObjectSomeValues ,pred q))))

	 ;;          ((fresh (q r)
	 ;;            (== b `(Not (ObjectIntersectionOf ,q ,r)))
	 ;; (project (q) (begin (print "NOT INT " q "\n\n") (== q q)))
	 ;;            (subclasso a `(ObjectUnionOf (Not ,q) (Not ,r)))))

	 ;;          ((fresh (q r)
	 ;;            (== b `(Not (ObjectUnionOf ,q ,r)))
	 ;; (project (q) (begin (print "NOT UNION" q "\n\n") (== q q)))
	 ;;            (subclasso a `(ObjectIntersectionOf (Not ,q) (Not ,r)))))



         ((fresh (q r)
           (== b `(Implies ,q ,r))
           (project (q r) (begin (print "right IMPLIES " q "\n\n") (== q q)))
           (subclasso a `(ObjectUnionOf ,r (Not ,q)))))

         ((fresh (q r)
           (== a `(Implies ,q ,r))
           (project (q r) (begin (print "left IMPLIES " q "\n\n") (== q q)))
           (subclasso `(ObjectUnionOf ,r (Not ,q)) b)))
           ;;(subclasso b `(ObjectUnionOf ,r (Not ,q)))))
           ;;(conde ((subclass b r)

