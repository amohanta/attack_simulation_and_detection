
# MuddyWater Campaign — Compromised Mailboxes & Espionage Operations

## 🧩 Overview
MuddyWater (also tracked as Seedworm or TEMP.Zagros) is an Iranian state-sponsored APT group known for espionage and data theft targeting government, telecom, energy, and defense sectors.  
Recent reports from **Infosecurity Magazine** and **Group-IB** highlight how the group compromised **Microsoft 365 mailboxes** and used them for **credential theft and internal reconnaissance**.

---

## ⚔️ Attack Flow (Text-Based Diagram)

```
[Initial Access]
     ↓
Phishing emails with malicious attachments or links
     ↓
[Execution]
     ↓
Malicious scripts (PowerShell/VBS) executed via attachments
     ↓
[Persistence]
     ↓
Scheduled tasks & registry run keys for re-execution
     ↓
[Credential Access]
     ↓
Compromise of Microsoft 365 mailboxes and credential harvesting
     ↓
[Discovery & Lateral Movement]
     ↓
Use of legitimate tools (PowerShell, RDP, SMB) for internal reconnaissance
     ↓
[Exfiltration]
     ↓
Stolen data and credentials exfiltrated to attacker-controlled servers
```

---

## 🔧 Tools and Techniques Used

| Phase | Tools / Methods | Description |
|-------|-----------------|--------------|
| **Initial Access** | Phishing, Weaponized Office docs | Used social engineering with malicious links or attachments |
| **Execution** | PowerShell, VBS, Batch scripts | Executes payloads to establish foothold |
| **Persistence** | Registry Run keys, Scheduled Tasks | Ensures long-term access |
| **Credential Access** | Mailbox access via OAuth tokens | Compromised cloud mailboxes for credentials |
| **Lateral Movement** | Remote Desktop Protocol (RDP), SMB | Used to move across network |
| **Exfiltration** | HTTPS, WebDAV, custom scripts | Data exfiltrated to remote servers |

---

## 🕵️ Observed Tactics, Techniques, and Procedures (TTPs)

| MITRE ATT&CK ID | Tactic | Technique |
|-----------------|---------|------------|
| T1566 | Initial Access | Phishing |
| T1059 | Execution | PowerShell |
| T1547 | Persistence | Registry Run Keys |
| T1110 | Credential Access | Brute Force / Password Guessing |
| T1087 | Discovery | Account Discovery |
| T1071 | Command and Control | Application Layer Protocol |
| T1041 | Exfiltration | Exfiltration over C2 Channel |

---

## 🌍 Target Sectors
- Government & Diplomatic Organizations  
- Telecommunications  
- Defense  
- Critical Infrastructure  
- Energy Sector  

---

## 🧠 Key Insights
- MuddyWater’s campaign leveraged compromised Microsoft 365 mailboxes to blend malicious activity with legitimate traffic.  
- The group used custom scripts and open-source tools for stealthy movement and credential theft.  
- The operation emphasizes the shift of APT actors toward **cloud-based espionage** and **living-off-the-land (LotL)** techniques.  

---

## 🔗 References

1. [Infosecurity Magazine — MuddyWater Compromised Microsoft 365 Mailboxes](https://www.infosecurity-magazine.com/news/muddywater-compromised-mailboxes/)  
2. [Group-IB — MuddyWater Espionage Operations](https://www.group-ib.com/blog/muddywater-espionage/)

---

**Author:** Threat Intelligence Summary — October 2025  
**Category:** APT Campaigns / Iranian Threat Actors
