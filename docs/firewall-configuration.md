# Firewall Configuration and Lab Hardening Report

## Overview

As part of the lab hardening process, firewalls were configured on both the **Ubuntu Server (UbuntuServer-26-IT-P2)** and the **Windows 11 Client (Windows-11-IT-P)**. Implementing firewalls restricts the attack surface of each host by adhering to the principle of least privilege—blocking all unsolicited inbound traffic by default and allowing only specific, necessary services.

---

## 1. Ubuntu Server Firewall Configuration (UFW)

The Ubuntu Server utilizes **UFW (Uncomplicated Firewall)** for packet filtering. The configuration follows a strict **default deny inbound** policy.

### Setup and Configuration Steps

1. **Initialize UFW**: Checked status and verified that UFW was active and enabled.
   ```bash
   sudo ufw status
   sudo ufw enable
   ```
2. **Define Default Policies**: Block all incoming connections and permit outgoing connections.
   ```bash
   sudo ufw default deny incoming
   sudo ufw default allow outgoing
   ```
3. **Allow Required Services**: Opened specific ports required for hosting services and administration.
   ```bash
   sudo ufw allow 22/tcp    # SSH Administration
   sudo ufw allow 80/tcp    # HTTP Web Traffic
   sudo ufw allow 443/tcp   # HTTPS Secure Web Traffic
   ```
4. **Restrict DNS Inbound Queries**: Allowed DNS traffic (Port 53) strictly from the lab subnet to prevent external DNS amplification attacks.
   ```bash
   sudo ufw allow from 192.168.0.0/24 to any port 53
   ```
5. **Verify Configuration**: Exported and reviewed the active rules.
   ```bash
   sudo ufw status verbose
   ```

### Configured Rules Summary

| Rule # | Action | Port/Protocol  | Source IP Scope  | Rationale                                                                         |
| :----- | :----- | :------------- | :--------------- | :-------------------------------------------------------------------------------- |
| **1**  | ALLOW  | `22/tcp`       | Any              | Allows administrative access via SSH (later restricted to key-only).              |
| **2**  | ALLOW  | `80/tcp`       | Any              | Allows inbound HTTP traffic for web applications.                                 |
| **3**  | ALLOW  | `443/tcp`      | Any              | Allows inbound HTTPS traffic for secure web services.                             |
| **4**  | ALLOW  | `53` (TCP/UDP) | `192.168.0.0/24` | Restricts DNS resolution services exclusively to internal lab machines.           |
| **5**  | DENY   | All Inbound    | Any              | Implicit default policy — blocks all traffic not explicitly allowed by Rules 1-4. |

The script used to initialize this configuration is saved at [ufw-rules.sh](../scripts/ufw-rules.sh).

---

## 2. Windows Defender Firewall Configuration

Windows 11 hosts crucial services, including Remote Desktop Protocol (RDP) for GUI-based administration. Exposed RDP interfaces are prime targets for automated brute-force attacks.

### Hardening Step: Restricting RDP Scope

To secure RDP access on **Windows-11-IT-P**, the inbound firewall rule was modified:

1. Opened **Windows Defender Firewall with Advanced Security**.
2. Located the inbound rule for **Remote Desktop - User Mode (TCP-In)** (Port `3389`).
3. Under the **Scope** tab, adjusted the **Remote IP Address** list:
   - Changed from **Any IP Address** to **These IP Addresses**.
   - Added the local lab subnet: `192.168.0.0/24`.
4. Verified that the rule Action was set to **Allow the connection**.

> [!IMPORTANT]
> Restricting RDP to the internal network prevents external attackers from attempting credential stuffing or exploiting vulnerabilities like BlueKeep (CVE-2019-0708) from the public internet.

---

## 3. Firewall Testing and Verification

To verify that the firewall rules were working as intended, network connection tests were simulated from the host machine (`192.168.0.5`) to the Ubuntu Server (`UbuntuServer-26-IT-P2`).

### Test 1: Closed/Blocked Port Connection (Port 8080)

Attempted to connect to port `8080`, which is not allowed under the UFW configuration.

- **Command run from host**:
  ```cmd
  telnet 192.168.0.1 8080
  ```
- **Result**: The connection timed out.
- **Security Analysis**: The firewall successfully dropped the packet silently without sending a TCP RST (reset) packet, which prevents port-scanning tools from quickly mapping out active hosts.

### Test 2: Opened Port Connection (Port 22)

Attempted to connect to the SSH service on port `22`.

- **Command run from host**:
  ```cmd
  telnet 192.168.0.1 22
  ```
- **Result**: Connection established successfully, showing the SSH service banner:
  ```text
  SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.1
  ```
- **Security Analysis**: UFW allowed traffic through port 22 as expected.

---

## 4. Key Security Concepts

### What is the difference between a Firewall and an Intrusion Detection System (IDS)?

- **Firewall**: Acts as a barrier that inspects packet headers (source IP, destination IP, ports, protocol) and blocks or allows traffic based on static rules. It does not inspect the payload content of the packet.
- **Intrusion Detection System (IDS)**: Monitors network traffic or host events and analyzes packet payloads for known malicious signatures or behavioral anomalies. An IDS alerts security teams to suspicious behavior but (unlike an IPS) does not block it.
