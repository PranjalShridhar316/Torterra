# Security Principles - Phase 1

## Purpose
Phase 1:Establishes the foundation of SSH hardening by removing insecure defaults.

## Key Actions
- Disabled root login (`PermitRootLogin no`).
- Disabled password authentication (`PasswordAuthentication no`).
- Enforced SSH key authentication (`PubkeyAuthentication yes`).

## Benefits
- Prevents brute-force attacks on root.
- Eliminates weak password vulnerabilities.
- Ensures only trusted devices with SSH keys can connect.

## Usage
1. Generate SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "your_name"
