
---
# Test Cases - Phase 1

## Test Case 1: Root Login Disabled
- **Setup:** Attempt SSH login as root.
- **Expected Output:** Access denied.

## Test Case 2: Password Login Disabled
- **Setup:** Attempt SSH login with password.
- **Expected Output:** Access denied.

## Test Case 3: Key Authentication Enforced
- **Setup:** Attempt SSH login with valid key.
- **Expected Output:** Successful login.

## Test Case 4: Invalid Key
- **Setup:** Attempt SSH login with wrong key.
- **Expected Output:** Access denied.


---

# Test Cases - Phase 2

## Test Case 1: No Failed Attempts
- **Setup:** No failed SSH logins.
- **Expected Output:** Only header line in `/var/log/failed_attempts.log`.

## Test Case 2: Single Failed Attempt
- **Setup:** Attempt login with wrong password once.
- **Expected Output:** One entry with timestamp and username.

## Test Case 3: Multiple Failed Attempts
- **Setup:** Attempt login with wrong password multiple times.
- **Expected Output:** Multiple entries listed in `/var/log/failed_attempts.log`.

## Test Case 4: Permissions Check
- **Setup:** Run script without `sudo`.
- **Expected Output:** Permission denied error for `/var/log/auth.log`.
