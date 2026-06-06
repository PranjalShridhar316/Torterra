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

## Test Case 5: Service Restart (Multi-Distro)
- **Setup:** Run script on Debian/Ubuntu.
- **Expected Output:** SSH service restarted (`systemctl restart ssh`).

- **Setup:** Run script on Red Hat/Fedora/Arch.
- **Expected Output:** SSH service restarted (`systemctl restart sshd`).

## Test Case 6: Ownership and Permissions
- **Setup:** Inspect `/home/<user>/.ssh/authorized_keys`.
- **Expected Output:** Owned by user, permissions set to `600`.

