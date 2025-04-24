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

;; Data Architecture Blueprint
;; -----------------------------


;; Time constraints for security operations
(define-constant SECURITY_DELAY_PERIOD u144) 

;; Core proposal information registry
(define-map ProposalCatalog
  { proposal-id: uint }
  {
    architect: principal,
    milestone-threshold: uint,
    current-backing: uint,
    deadline: uint,
    lifecycle-phase: (string-ascii 10)
  }
)

;; Participant contribution ledger
(define-map ParticipantLedger
  { proposal-id: uint, participant: principal }
  { allocation-amount: uint }
)

;; Protocol state tracking
(define-data-var proposal-sequence uint u0)

;; Maximum individual contribution safeguard
(define-constant MAX_INDIVIDUAL_ALLOCATION u50000000000) 

(define-constant SIGNIFICANT_ALLOCATION_THRESHOLD u1000000000)

;; Interaction frequency limitation window
(define-constant FREQUENCY_WINDOW_SIZE u72) 
(define-constant MAX_INTERACTIONS_PER_WINDOW u5)
(define-constant DAILY_BLOCK_COUNT u144) 

;; -----------------------------
;; Helper Functions
;; -----------------------------

;; Validates proposal existence by identifier
(define-private (proposal-registered (proposal-id uint))
  (<= proposal-id (var-get proposal-sequence))
)

;; Determines if proposal is in a backable phase
(define-private (is-proposal-backable (lifecycle-phase (string-ascii 10)))
  (is-eq lifecycle-phase "active")
)

;; -----------------------------
;; Proposal Backing Operations
;; -----------------------------

;; Enables participants to allocate resources to proposals
(define-public (allocate-to-proposal (proposal-id uint) (allocation-size uint))
  (begin
    (asserts! (> allocation-size u0) (err CODE_INVALID_ALLOCATION))
    (asserts! (proposal-registered proposal-id) (err CODE_PROPOSAL_NOT_FOUND))
    (let
      (
        (proposal-details (unwrap! (map-get? ProposalCatalog { proposal-id: proposal-id }) (err CODE_PROPOSAL_NOT_FOUND)))
        (current-phase (get lifecycle-phase proposal-details))
        (total-backing (get current-backing proposal-details))
        (new-total-backing (+ total-backing allocation-size))
      )
      (asserts! (is-proposal-backable current-phase) (err CODE_PROPOSAL_SEALED))
      (asserts! (<= block-height (get deadline proposal-details)) (err CODE_PROPOSAL_SEALED))
      (match (stx-transfer? allocation-size tx-sender (as-contract tx-sender))
        success
          (begin
            (map-set ProposalCatalog
              { proposal-id: proposal-id }
              (merge proposal-details { current-backing: new-total-backing })
            )
            (map-set ParticipantLedger
              { proposal-id: proposal-id, participant: tx-sender }
              { allocation-amount: allocation-size }
            )
            (print {event: "allocation_received", proposal-id: proposal-id, participant: tx-sender, amount: allocation-size})
            (ok true)
          )
        failure (err CODE_TRANSFER_FAILURE)
      )
    )
  )
)

;; Enhanced allocation with safety guardrails
(define-public (secure-proposal-allocation (proposal-id uint) (allocation-size uint))
  (begin
    (asserts! (> allocation-size u0) (err CODE_INVALID_ALLOCATION))
    (asserts! (<= allocation-size MAX_INDIVIDUAL_ALLOCATION) (err CODE_ALLOCATION_LIMIT_EXCEEDED))
    (asserts! (proposal-registered proposal-id) (err CODE_PROPOSAL_NOT_FOUND))
    (let
      (
        (proposal-details (unwrap! (map-get? ProposalCatalog { proposal-id: proposal-id }) (err CODE_PROPOSAL_NOT_FOUND)))
        (current-phase (get lifecycle-phase proposal-details))
        (total-backing (get current-backing proposal-details))
        (new-total-backing (+ total-backing allocation-size))
        (participant-record (default-to { allocation-amount: u0 } 
                          (map-get? ParticipantLedger { proposal-id: proposal-id, participant: tx-sender })))
        (existing-allocation (get allocation-amount participant-record))
        (total-participant-allocation (+ existing-allocation allocation-size))
      )
      ;; Enforce individual allocation limits
      (asserts! (<= total-participant-allocation MAX_INDIVIDUAL_ALLOCATION) (err CODE_ALLOCATION_LIMIT_EXCEEDED))
      (asserts! (is-proposal-backable current-phase) (err CODE_PROPOSAL_SEALED))
      (asserts! (<= block-height (get deadline proposal-details)) (err CODE_PROPOSAL_SEALED))

      (match (stx-transfer? allocation-size tx-sender (as-contract tx-sender))
        success
          (begin
            (map-set ProposalCatalog
              { proposal-id: proposal-id }
              (merge proposal-details { current-backing: new-total-backing })
            )
            (map-set ParticipantLedger
              { proposal-id: proposal-id, participant: tx-sender }
              { allocation-amount: total-participant-allocation }
            )
            (print {event: "secure_allocation_recorded", proposal-id: proposal-id, participant: tx-sender, amount: allocation-size})
            (ok true)
          )
        failure (err CODE_TRANSFER_FAILURE)
      )
    )
  )
)
