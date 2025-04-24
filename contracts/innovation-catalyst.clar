;; Community Innovation Catalyst 

;; Core configuration parameters
(define-constant ECOSYSTEM_STEWARD tx-sender)
(define-constant PROPOSAL_DURATION u2016) 
(define-constant CODE_PERMISSION_DENIED (err u200))
(define-constant CODE_PROPOSAL_NOT_FOUND (err u201))
(define-constant CODE_INVALID_ALLOCATION (err u202))
(define-constant CODE_PROPOSAL_SEALED (err u203))
(define-constant CODE_NO_ALLOCATION_EXISTS (err u213))
(define-constant CODE_STEWARDSHIP_TRANSFER_FAILED (err u214))
(define-constant CODE_ALLOCATION_QUOTA_EXCEEDED (err u216))
(define-constant CODE_MILESTONE_UNREACHED (err u204))
(define-constant CODE_TRANSFER_FAILURE (err u205))
(define-constant CODE_ALLOCATION_LIMIT_EXCEEDED (err u206))
(define-constant CODE_REFUND_UNAVAILABLE (err u212))
(define-constant CODE_INTERACTION_FREQUENCY_EXCEEDED (err u220))

