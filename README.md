# Security, Monitoring, and Incident Response Lab

## Project Overview

This project simulates a real-world security operations workflow: **harden, monitor, detect, respond, and document.**

The lab environment consists of a **Ubuntu Server** and a **Windows 11 Client** running inside VirtualBox, with a **Splunk Enterprise** instance on the host machine acting as a centralized SIEM (Security Information and Event Management) platform.

The goal is to demonstrate a complete security incident lifecycle — from proactive system hardening and vulnerability discovery, through log aggregation and detection, to structured incident response and documentation.

---

## Lab Environment

| Component             | OS/Role           | IP Address     | Purpose                                          |
| :-------------------- | :---------------- | :------------- | :----------------------------------------------- |
| **Splunk Host**       | Windows 11 (Host) | `192.168.0.5`  | Splunk Enterprise Indexer & Search Head          |
| **Ubuntu Server**     | Ubuntu 22.04      | `192.168.0.1`  | Web/DNS server, source of SSH logs               |
| **Windows 11 Client** | Windows 11        | `192.168.0.10` | Source of Windows Event Logs (Security & System) |

---

## Workflow Overview

The project follows a **defense-in-depth** approach in five phases:

### Phase 1 — Firewall Configuration (Hardening)

Before any monitoring can be effective, the attack surface must be reduced. Host-based firewalls were configured on both the Ubuntu Server (UFW) and Windows 11 Client (Windows Defender Firewall).

- **Ubuntu UFW Rules**: Default deny inbound, allow only SSH (22), HTTP (80), HTTPS (443), and DNS (53) restricted to the lab subnet (`192.168.0.0/24`).
- **Windows Firewall**: RDP (3389) restricted to the lab subnet only, preventing external brute-force attempts.

[View Full Firewall Configuration →](./docs/firewall-configuration.md)

---

### Phase 2 — Vulnerability Scanning (Reconnaissance)

With firewalls in place, active reconnaissance was performed using **Nmap** to discover live hosts, identify open ports, and detect running service versions.

- **Ping Sweep** (`nmap -sn`): Identified all active devices on the lab network.
- **Service/OS Scan** (`nmap -sV -O`): Detected OpenSSH 8.9, Apache, and BIND DNS versions, allowing risk assessment against known CVEs.

[View Full Nmap Scan Results →](./docs/nmap-scan-results.md)

---

### Phase 3 — SIEM Implementation (Log Aggregation & Monitoring)

A centralized logging pipeline was built using **Splunk Enterprise** on the host machine, with **Splunk Universal Forwarders** deployed on both VMs to ship logs to the indexer.

- **Ubuntu Forwarder**: Monitors `/var/log/auth.log` and `/var/log/syslog`.
- **Windows Forwarder**: Monitors Security and System Event Logs (Event Codes 4625, 4720).
- **Reports Created**:
  - Failed SSH attempts (Ubuntu)
  - Failed Windows logons (EventCode 4625)
  - New user account creation (EventCode 4720)

[View Full Splunk Setup →](./docs/splunk-setup.md)

---

### Phase 4 — Incident Simulation (Detection)

A realistic security incident was simulated to test the monitoring pipeline and demonstrate detection capabilities:

- **Brute Force Attack**: 5–6 failed SSH login attempts were generated from the host machine against the Ubuntu Server.
- **Unauthorized User Creation**: A suspicious local account (`suspicious.user`) was created on the Windows 11 Client.

**Detection Searches**:

- `index=* source="/var/log/auth.log" "Failed password" | stats count by host`
- `index=* EventCode=4720 suspicious.user`

Screenshots of these detections were captured as evidence.

[View Incident Report →](./docs/incident-report-001.md)

---

### Phase 5 — Incident Response (Documentation)

A formal **Incident Response Report (IR-001)** was written following industry-standard structure:

- Summary
- Timeline
- Detection methodology
- Evidence (Screenshots)
- Root cause analysis
- Response actions taken
- Recommendations for prevention

This demonstrates the full incident lifecycle — detection, containment, eradication, and recovery.

[Read Full Incident Report →](./docs/incident-report-001.md)

---

## Tech Stack & Tools

| Category              | Tools Used                                   |
| :-------------------- | :------------------------------------------- |
| **Virtualization**    | Oracle VirtualBox                            |
| **Operating Systems** | Ubuntu 22.04, Windows 11                     |
| **Firewalls**         | UFW (Ubuntu), Windows Defender Firewall      |
| **Reconnaissance**    | Nmap (CLI)                                   |
| **SIEM Platform**     | Splunk Enterprise (Free)                     |
| **Log Forwarding**    | Splunk Universal Forwarder (Linux & Windows) |
| **Documentation**     | Markdown, Mermaid Diagrams                   |

---

## Key Security Concepts Demonstrated

| Concept                          | How It Was Applied                                                                         |
| :------------------------------- | :----------------------------------------------------------------------------------------- |
| **Principle of Least Privilege** | Firewalls deny all inbound traffic by default, allowing only explicitly required services. |
| **Defense in Depth**             | Firewalls + SIEM monitoring + Nmap scanning + Incident Response.                           |
| **SIEM Correlation**             | Centralized log aggregation enables cross-platform event correlation.                      |
| **Incident Lifecycle**           | Detection, investigation, containment, eradication, and documentation.                     |
| **Vulnerability Management**     | Nmap version detection identifies services for CVE tracking.                               |

---

## Repository Structure

```text
security-monitoring-and-incident-response-lab/
├── README.md                              # This file
├── docs/
│   ├── firewall-configuration.md          # UFW + Windows Defender setup
│   ├── nmap-scan-results.md               # Ping sweep + port/OS scan
│   ├── splunk-setup.md                    # Splunk deployment & forwarders
│   └── incident-report-001.md             # Formal IR write-up
├── scripts/
│   └── ufw-rules.sh                       # UFW hardening script
└── screenshots/
    ├── brute_force_detection.png
    └── unauthorized_user_creation.png
```