# 🧪 Torterra – Test Cases

## 📖 Overview
This file documents the **manual and automated test cases** used to validate each phase of Torterra.  
It ensures reproducibility, clarity, and professional verification of the toolkit’s functionality.

---

## 🔹 Phase 1 – Hardening
- **Test 1:** Attempt SSH login as `root` → should be denied.
- **Test 2:** Attempt password‑based login → should be denied.
- **Test 3:** Attempt key‑based login with valid key → should succeed.
- **Test 4:** Attempt key‑based login with invalid key → should fail.

---

## 🔹 Phase 2 – Monitoring
- **Test 1:** Trigger 3 failed login attempts → verify alert in logs.
- **Test 2:** Check `/var/log/auth.log` → failed attempts recorded.
- **Test 3:** Dashboard should show failed login count.

---

## 🔹 Phase 3 – Intrusion Prevention
- **Test 1:** Simulate brute force login attempts → IP should be blocked.
- **Test 2:** Verify blocked IP in `/etc/hosts.deny` or firewall rules.
- **Test 3:** Dashboard should show “Intrusion Prevention Active.”

---

## 🔹 Phase 4 – Incident Response
- **Test 1:** Trigger failed login → incident logged in `/var/log/ssh_incidents.log`.
- **Test 2:** Verify incident response script runs automatically.
- **Test 3:** Dashboard should display incident alert.

---

## 🔹 Phase 5 – Auditing
- **Test 1:** Run `rep_audit.sh` → verify SSH config compliance.
- **Test 2:** Check for insecure options (`PermitRootLogin yes`, `PasswordAuthentication yes`) → should be flagged.
- **Test 3:** Dashboard should show audit summary.

---

## 🔹 Phase 6 – Threat Simulation
- **Test 1:** Run `thrt_simulation.sh` brute force → system should detect and block.
- **Test 2:** Run port scan → open ports should be listed.
- **Test 3:** Dashboard should show simulation results.

---

## ✅ Expected Outcome
- All hardening, monitoring, prevention, response, auditing, and simulation scripts work as intended.  
- Dashboard provides **real‑time visibility** of test results.  
- Logs are consistent and reproducible for academic and professional review.
