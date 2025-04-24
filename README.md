# Community Innovation Catalyst

The **Community Innovation Catalyst** is a Clarity smart contract protocol designed to support decentralized, milestone-based funding of community proposals. It includes mechanisms for secure resource allocation, rate limiting, milestone verification, stewardship transitions, and emergency recovery/refund pathways.

## 🌐 Overview

This protocol empowers communities to back innovation by allowing participants to:

- Allocate funds to proposals in different phases.
- Enforce individual and global allocation limits.
- Rate-limit interactions to prevent abuse.
- Track milestone achievements for proposals.
- Claim resources with optional security delays.
- Recover allocations or request emergency refunds.
- Manage steward roles securely.

## 📦 Features

- **Milestone-Based Fund Release:** Secure and verifiable disbursement of funds upon achieving specific milestones.
- **Secure Allocation Mechanisms:** Includes standard, guarded, and rate-limited resource backing options.
- **Emergency Allocation Recovery:** Options for participants to retrieve funds from expired or paused proposals.
- **Stewardship Management:** Two-step process to securely transfer proposal control.
- **Anti-Spam Throttling:** Rate limits to prevent spammy or abusive transactions.
- **Security Delay for High-Value Transfers:** Delayed claims for large milestone achievements to enhance protocol safety.

## 🛠 Contract Structure

Key data structures and maps:
- `ProposalCatalog`: Stores metadata for each proposal.
- `ParticipantLedger`: Tracks individual contributions.
- `ParticipantInteractionThrottle`: Tracks frequency of participant interactions.
- `ResourceClaimRequests`: Handles delayed resource claims.
- `StewardshipTransferRequests`: Manages stewardship handoffs.
- `AllocationQuotaControls`: (To be implemented) Enforces quota caps on funding flows.

## 🚀 Deployment

To deploy the smart contract:

1. Install [Clarinet](https://docs.stacks.co/docs/clarity/clarinet-cli) if not already.
2. Clone the repository:
   ```bash
   git clone https://github.com/your-username/community-innovation-catalyst.git
   cd community-innovation-catalyst
   ```
3. Deploy with Clarinet:
   ```bash
   clarinet test
   clarinet integrate
   ```

## 🧪 Testing

Run unit tests with:
```bash
clarinet test
```

Test scenarios include:
- Standard and secure allocations
- Milestone claims (instant and delayed)
- Proposal expiration recovery
- Emergency refund execution
- Stewardship transition logic

## 📄 License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.

## 🤝 Contributing

Contributions, issues, and suggestions are welcome! For major changes, please open an issue first to discuss what you'd like to change.
