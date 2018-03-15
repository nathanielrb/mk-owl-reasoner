(define recipients
  '((AnyRecipient top)
    (ours AnyRecipient)
    (delivery AnyRecipient)
    (same  AnyRecipient)
    (other-recipient AnyRecipient)
    (unrelated AnyRecipient)
    (public AnyRecipient)))

(define places
  '((svl:EU svl:World)
    (svl:EULike svl:World)
    (svl:ThirdCountries svl:World)))

(define purposes
  '((AnyPurpose top)
    (Admin AnyPurpose)
    
    (AnyContact AnyPurpose)
    (Telemarketing AnyContact)
    (OtherContact AnyContact)

    (AuxPurpose AnyPurpose)
    (Account AuxPurpose)
    (Custom AuxPurpose)
    (Delivery AuxPurpose)
    (Feedback AuxPurpose)
    (Login AuxPurpose)
    (Marketing AuxPurpose)
    (Payment AuxPurpose)
    (State AuxPurpose)

    (Current AnyPurpose)
    (Arts Current)
    (Browsing Current)
    (Charity Current)
    (Community Current)
    (Downloads  Current)
    (Education Current)
    (Finmgt Current)
    (Gambling Current)
    (Gaming Current)
    (Government Current)
    (Health Current)
    (News Current)
    (Sales Current)
    (Search Current)

    (Painting Arts)

    (Develop AnyPurpose)
    (Historical AnyPurpose)
    (Tailoring AnyPurpose)
    ))

(define datatypes
  '((AnyData top)
    (PersonalData AnyData)
    (PseudonymizedData AnyData)
    (NavigationData AnyData)
    (LocationData AnyData)
     ))

(define operations
  '((AnyProcessing top)
    (use AnyProcessing)
    (grantUse AnyProcessing)
    (acceptTracking AnyProcessing)
    (aggregate AnyProcessing)
    (anonymize AnyProcessing)
    (archive AnyProcessing)
    (copy AnyProcessing)
    (derive AnyProcessing)
    (digitize AnyProcessing)
    (distribute AnyProcessing)
    (give AnyProcessing)
    (move AnyProcessing)
    (read AnyProcessing)
    (secondaryUse AnyProcessing)
    (sell AnyProcessing)
    (transfer AnyProcessing)
    (share AnyProcessing)))

;; cheating!!

(define types `((spl:hasData ,datatypes)
                (spl:hasPurpose ,purposes)
                (spl:hasProcessing ,operations)))
