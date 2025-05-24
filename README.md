G-Naira (gNGN) Token

G-Naira (gNGN) is a blockchain-based financial solution developed for the Central Bank to digitize the national currency with transparency, accountability, and programmable control.

This contract is deployed on the Somnia Testnet to demonstrate:

ERC20 compliance

Role-based access via GOVERNOR

Minting and burning of tokens

Address blacklisting

Optional multisignature control for sensitive operations

Contracts on Somnia Testnet

Contract Address

Feature Description

0xBCc55676f3229bB6A5E0300005E5230B45a04bc1

 gNGN token with multisig mint/burn

0xad8C3EBFE2fD9EE5F60591f9C495A0d23A81764D

 gNGN token with single GOVERNOR role

Key Features

ERC20 Standard

Fully compliant with OpenZeppelin's ERC20 implementation

GOVERNOR Role

Only addresses assigned the GOVERNOR_ROLE can:

Mint new gNGN tokens

Burn tokens from circulation

Blacklist or unblacklist accounts

Multisig Minting & Burning (on 0xBCc5... contract)

Governors must propose a mint or burn

A minimum of 2 approvals (2-of-N) are required to execute the action

Proposals are automatically executed when quorum is reached

Blacklisting

Blacklisted addresses cannot send or receive gNGN

 Testing & Deployment

Network: Somnia DevNet/Testnet

Wallet: Connect via MetaMask using "Injected Web3"

Test addresses were assigned the GOVERNOR_ROLE at deployment

  License

This project is open-sourced under the MIT License.

For integration help, UI dashboard, or multisig expansion, feel free to reach out.

