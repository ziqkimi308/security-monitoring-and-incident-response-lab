# Security, Monitoring, and Incident Response Lab (Project 4)

## Project Overview
This repository contains the documentation, configuration files, and incident logs for **Project 4: Security, Monitoring, and Incident Response**. 

The goal of this project is to implement active security controls, monitor network assets for vulnerabilities and events using a Centralized SIEM, simulate a security intrusion, and execute a formal incident response process.

---

## 📂 Repository Structure

The project resources and reports are organized as follows:

* 📄 **[`README.md`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/README.md)**: Main landing page for the project portfolio.
* 📂 **[`/docs`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/docs)**: Core lab reports and incident documentation.
  * 📄 **[`firewall-configuration.md`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/docs/firewall-configuration.md)**: Details on configuring host-based firewalls (UFW on Ubuntu and Windows Defender Firewall) and connectivity testing.
  * 📄 **[`nmap-scan-results.md`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/docs/nmap-scan-results.md)**: Details network discovery (ping sweeps) and OS/service version vulnerability scanning using Nmap.
  * 📄 **[`splunk-setup.md`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/docs/splunk-setup.md)**: Steps for deploying Splunk Enterprise and configuring universal forwarders for log aggregation and monitoring.
  * 📄 **[`incident-report-001.md`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/docs/incident-report-001.md)**: Official Incident Response (IR) report for a simulated SSH brute-force attack and unauthorized user creation event.
* 📂 **[`/scripts`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/scripts)**: Scripts implemented for system hardening.
  * 📄 **[`ufw-rules.sh`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/scripts/ufw-rules.sh)**: Shell script containing the hardening commands used to set up the Ubuntu firewall.
* 📂 **[`/screenshots`](file:///E:/Learning/Cloud%20DevOps%20&%20System/IT%20Projects/security-monitoring-and-incident-response-lab/screenshots)**: Logs and interface captures demonstrating rule testing, scan validation, and detection telemetry.

---

## 🛠️ Lab Tech Stack & Tools Used
* **Virtualization**: Oracle VirtualBox (Windows & Linux VMs)
* **Firewalls**: UFW (Ubuntu), Windows Defender Firewall
* **Scanning & Recon**: Nmap (CLI-based)
* **SIEM Platform**: Splunk Free Enterprise (Ingestion, Indexing, and Reporting)
* **Endpoint Forwarding**: Splunk Universal Forwarder (Linux and Windows)
* **Documentation**: Markdown, Mermaid Diagrams
