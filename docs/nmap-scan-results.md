# Vulnerability Scanning with Nmap

## Overview

Reconnaissance is the first step in assessing a network's security posture. This report details the network scans performed using **Nmap (Network Mapper)** to discover active hosts, map open ports, identify running services, detect operating system versions, and assess potential entry points for attackers.

---

## 1. Active Asset Discovery (Ping Sweep)

Before scanning for open ports, a ping sweep was conducted to identify all active devices within the lab environment.

### Execution Command

```bash
nmap -sn 192.168.0.0/24
```

### Analysis of the `-sn` Flag

- **Function**: Disables port scanning. Nmap only performs host discovery (using ICMP echo requests, TCP SYN to port 443, TCP ACK to port 80, and ICMP timestamp requests).
- **Use Case**: In IT support and security administration, a ping sweep is used to build a rapid inventory of online systems and detect **rogue devices** (unauthorized systems connected to the network) without generating excessive traffic or triggering security alerts.

### Discovered Hosts

- **`192.168.0.1`** — Ubuntu Server Gateway/Host (hosting UFW)
- **`192.168.0.5`** — Windows Client/Security workstation (where Nmap and Splunk are hosted)
- **`192.168.0.10`** — Windows Server Domain Controller

---

## 2. Comprehensive Port and OS Scan

A detailed scan was executed targeting the Ubuntu Server (`UbuntuServer-26-IT-P2` at `192.168.0.1`) to identify running services and operating system details.

### Execution Command

```bash
nmap -sV -O 192.168.0.1
```
Detected OS: Linux 4.15 - 5.8 (Ubuntu)

### Explanation of Scan Flags

- **`-sV` (Service Version Detection)**: Probes open ports to determine service names and version details. This is critical for vulnerability management, as it allows administrators to cross-reference version numbers with known CVEs (Common Vulnerabilities and Exposures).
- **`-O` (OS Detection)**: Sends a series of TCP and UDP packets to the target and analyzes the responses. By comparing these packets against Nmap's database of operating system fingerprints, it estimates the remote OS and kernel version.

---

## 3. Annotated Scan Results & Risk Assessment

Below is a detailed analysis of the ports identified during the Nmap scan:

| Port/Protocol  | Service Name         | Version Detected       | Status         | Inbound Rule Check        | Risk Level | Threat Analysis & Mitigation                                                                                                                                                                      |
| :------------- | :------------------- | :--------------------- | :------------- | :------------------------ | :--------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`22/tcp`**   | SSH                  | `OpenSSH 8.9p1`        | **Open**       | Allowed by UFW            | **Medium** | **Threat:** Brute-force attacks and credential stuffing.<br>**Mitigation:** Disable password authentication, enforce SSH keys, and implement Fail2ban.                                            |
| **`53/tcp`**   | Domain (DNS)         | `ISC BIND 9.18`        | **Open**       | Allowed (Lab Subnet Only) | **Low**    | **Threat:** DNS spoofing, cache poisoning, or DNS amplification DDoS attacks.<br>**Mitigation:** Firewall scope restricted to `192.168.0.0/24`. Bind server to internal interfaces only.          |
| **`80/tcp`**   | HTTP                 | `Apache httpd`         | **Open**       | Allowed by UFW            | **Low**    | **Threat:** Unencrypted web traffic (e.g. session hijacking).<br>**Mitigation:** Force redirect to HTTPS (Port 443) and implement SSL/TLS certificates.                                           |
| **`3389/tcp`** | RDP (Windows Target) | `MS Terminal Services` | **Open** | Allowed (Lab Subnet Only) | **High**   | **Threat:** Remote code execution (e.g. BlueKeep) or unauthorized GUI access.<br>**Mitigation:** Restrict access using Windows Defender Firewall to trusted internal IPs. Enable MFA if possible. |

---

## 4. Key Security Concepts

### What does Nmap `-sV` do and why is it useful?

- **What it does**: `-sV` sends specific queries (probes) to active ports to determine what software and version are running, rather than just relying on standard port-to-service mapping (e.g., assuming port 22 is always OpenSSH).
- **Why it is useful**: It provides the exact software version (such as `OpenSSH 8.9p1`). This enables security analysts to find corresponding vulnerabilities in databases like the National Vulnerability Database (NVD) without needing to log in to the host machine.
