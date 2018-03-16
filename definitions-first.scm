(define recipients
  '((spl:AnyRecipient top)
    (spl:ours spl:AnyRecipient)
    (spl:delivery spl:AnyRecipient)
    (spl:same  spl:AnyRecipient)
    (spl:other-recipient spl:AnyRecipient)
    (spl:unrelated spl:AnyRecipient)
    (spl:public spl:AnyRecipient)))

(define places
  '((svl:EU svl:World)
    (svl:EULike svl:World)
    (svl:ThirdCountries svl:World)))

(define purposes
  '((spl:AnyPurpose top)
    (spl:Admin spl:AnyPurpose)
    
    (spl:AnyContact spl:AnyPurpose)
    (spl:Telemarketing spl:AnyContact)
    (spl:OtherContact spl:AnyContact)

    (spl:AuxPurpose spl:AnyPurpose)
    (spl:Account AuxPurpose)
    (spl:Custom AuxPurpose)
    (spl:Delivery AuxPurpose)
    (spl:Feedback AuxPurpose)
    (spl:Login AuxPurpose)
    (spl:Marketing AuxPurpose)
    (spl:Payment AuxPurpose)
    (spl:State AuxPurpose)

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
    ))

(define datatypes
  '((spl:AnyData top)
    (spl:PersonalData spl:AnyData)
    (spl:PseudonymizedData spl:AnyData)
    (spl:NavigationData spl:AnyData)
    (spl:LocationData spl:AnyData)
     ))

(define operations
  '((spl:AnyProcessing top)
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

;; cheating!!

(define types `((spl:hasData ,datatypes)
                (spl:hasPurpose ,purposes)
                (spl:hasProcessing ,operations)))
