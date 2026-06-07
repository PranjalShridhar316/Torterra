# 🛡️ Torterra – SSH Hardening & Security Toolkit

## 📖 Overview
Torterra is a **multi‑phase cybersecurity toolkit** designed to secure SSH access through **hardening, monitoring, intrusion prevention, incident response, auditing, and threat simulation**.  
It demonstrates **automation, scripting, and applied security practices** — making it both an academic project and a professional showcase of system hardening skills.

---

## 🚀 Key Features (Phase 1–6)
- **Phase 1 – Basic Hardening**
  - Disable root login (`dis_root.sh`)
  - Enforce key‑based authentication (`key_setup.sh`)

- **Phase 2 – Monitoring**
  - Track failed login attempts (`monitor_logins.sh`)
  - Generate alerts for suspicious activity

- **Phase 3 – Intrusion Prevention**
  - Block malicious IPs (`intrusion_prevention.sh`)
  - Fail2ban‑style protections

- **Phase 4 – Incident Response & Recovery**
  - Log incidents to `/var/log/ssh_incidents.log`
  - Document response actions (`docs/phase4_incident_response.md`)

- **Phase 5 – Continuous Monitoring & Auditing**
  - Audit SSH configs (`audit_ssh.sh`)
  - Forward logs to SIEM for deeper analysis

- **Phase 6 – Threat Simulation & Resilience Testing**
  - Brute‑force simulation
  - Port scanning (`thrt_simulation.sh`)
  - Hardening checks against `sshd_config`

---

## 📂 Project Structure
Torterra/
├── scripts/        # Automation scripts for each phase
│   ├── dis_root.sh
│   ├── key_setup.sh
│   ├── monitor_logins.sh
│   ├── intrusion_prevention.sh
│   ├── thrt_simulation.sh
│   ├── audit_ssh.sh
├── docs/           # Documentation per phase
│   ├── phase1_hardening.md
│   ├── phase2_monitoring.md
│   ├── phase3_intrusion_prevention.md
│   ├── phase4_incident_response.md
│   ├── phase5_auditing.md
│   └── phase6_threat_testing.md
├── tests/          # Validation scenarios
│   └── test_cases.md
└── README.md


---

## ⚙️ Usage
1. **Clone the repo**
   ```bash
   git clone https://github.com/Pranjal/Torterra.git
   cd Torterra/scripts
