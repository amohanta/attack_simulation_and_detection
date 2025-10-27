# MuddyWater Espionage Operation – Combined Analysis

**Sources:**
- [Infosecurity Magazine – MuddyWater Compromised Mailboxes](https://www.infosecurity-magazine.com/news/muddywater-compromised-mailboxes/)
- [Group-IB Blog – Unmasking MuddyWater’s New Malware Toolkit Driving International Espionage](https://www.group-ib.com/blog/muddywater-espionage/)

---

## SUMMARY OVERVIEW

MuddyWater, an Iranian threat group (also tracked as **Static Kitten** or **Seedworm**), continues to refine its espionage campaigns targeting government, defense, telecom, and energy sectors in the Middle East, Asia, and Europe.  
Recent campaigns leveraged **compromised mailboxes** and **malware updates (FakeUpdate + Phoenix Backdoor v4)** for persistence, credential theft, and remote control.

The latest operation shows an evolution of their phishing and malware delivery tactics, including the use of **NordVPN** infrastructure to send phishing emails, **custom loaders**, and **multi-stage infection** with **data exfiltration** and **command execution** via backdoors.

---

## ATTACK FLOW DIAGRAM

```
                [Start of Attack]
                        │
                        ▼
      Compromised Email Account (via NordVPN)
                        │
                        ▼
       Phishing Emails Sent to Multiple Targets
                        │
                        ▼
        Malicious Word Attachment (.doc/.docm)
                        │
                        ▼
   Victim Opens File → Sees Blurred Content & Prompt
        "Enable Content" → Enables Macros
                        │
                        ▼
     VBA Macro Executes → Decodes & Drops Loader
                        │
                        ▼
           [FakeUpdate Loader / Injector]
        - Decrypts 2nd Stage (AES)
        - Injects Payload into Itself
                        │
                        ▼
           [Phoenix Backdoor v4 Deployed]
        - Writes itself as sysProcUpdate.exe
        - Registers host with C2
        - Begins beaconing and command polling
        - Enables remote control and data theft
                        │
                        ▼
              [Post-Exploitation Phase]
        - Remote commands, data exfiltration,
          further lateral movement
                        │
                        ▼
                     [End of Flow]
```

---

## PHASE 1: INITIAL ACCESS

- Attackers gained access to **legitimate email accounts** belonging to targeted organizations.  
- These **compromised mailboxes** were then used to **send phishing emails** to other victims.  
- Emails originated from **NordVPN exit nodes**, primarily in **France**.  
- Phishing messages included **malicious Word attachments (.doc/.docm)** with embedded **VBA macros**.  
- Upon opening, the victim sees blurred content prompting them to *“Enable Content”*, triggering macro execution.  
- The macro drops and executes a loader file named **ManagerProc.log**.

**Tools/Techniques:**
- VPN anonymization (NordVPN)  
- Malicious Word document with VBA macros  
- Social engineering (blurred content trick)  
- Dropper payload written to `Public Documents` folder  

---

## PHASE 2: EXECUTION / LOADING

- The macro executes **FakeUpdate**, a loader/injector malware.  
- FakeUpdate decrypts a **second-stage payload** using AES encryption.  
- The second stage is identified as **Phoenix Backdoor v4**.  
- Payload is injected into the same process for stealth.  

**Tools/Techniques:**
- AES decryption  
- Process injection  
- Custom loader (FakeUpdate)  
- Phoenix Backdoor v4  

---

## PHOENIX BACKDOOR v4 DETAILS

**Dropped by:** FakeUpdate Injector  
**Type:** Second-stage backdoor  
**Execution:** Decrypted and injected into its own process  

**Functions & Capabilities:**
1. Creates a mutex named `sysprocupdate.exe` to ensure single instance.  
2. Gathers system information:
   - Computer name  
   - Domain/workgroup  
   - Windows version  
   - Current username  
3. Copies itself to:  
   `C:\ProgramData\sysprocupdate.exe`  
4. Achieves persistence by modifying:
   ```
   Registry:
   HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
   Shell → sysprocupdate.exe
   ```
5. Communicates with C2 using **WinHTTP**.
6. Accepts and executes remote commands.  
7. **PDB path found:**  
   `C:\Users\win10\Desktop\phoenixV4\phoenixV3\phoenixV2\x64\Debug\phoenix.pdb`

---

## PHASE 3: PERSISTENCE

- Phoenix v4 achieves persistence via:
  - Copying itself to ProgramData  
  - Creating a mutex `sysprocupdate.exe`  
  - Modifying **Winlogon Shell registry key**  
  - Launching **Mononoke.exe** via embedded COM DLL for extra persistence  

**Tools/Techniques:**
- Registry persistence  
- Mutex creation  
- COM DLL loader  
- File copy for system-level startup  

---

## PHASE 4: COMMAND & CONTROL (C2)

- Main C2 domain: `screenai[.]online` (IP: `159.198.36.115`)  
- Uses **WinHTTP** for communication and command polling  
- Supported commands include:
  - 68 → Upload file  
  - 85 → Download file  
  - 67 → Start shell  
  - 83 → Change sleep interval  
  - 65 → Sleep  

- Attackers also leveraged **RMM utilities** for persistence and control:
  - PDQ RMM  
  - Action1  
- C2 servers were protected using **Cloudflare**.

**Tools/Techniques:**
- WinHTTP-based beaconing  
- Encrypted C2 communications  
- Cloudflare protection  
- RMM tools for extended access  

---

## PHASE 5: CREDENTIAL THEFT / EXFILTRATION

- Attackers used **Chromium_Stealer**, disguised as a **Calculator app**, for browser credential theft.  
- Extracted encrypted keys (`os_crypt.encrypted_key`) from Chromium-based browsers:
  - Chrome  
  - Edge  
  - Opera  
  - Brave  
- Decrypted and stored credentials locally in `cobe-notes.txt`.  
- Data exfiltrated through **Phoenix backdoor**.

**Tools/Techniques:**
- Browser credential extraction  
- Local staging of credentials  
- Decryption of browser-protected storage  
- File upload to C2  

---

## PHASE 6: INFRASTRUCTURE & OPERATIONAL TECHNIQUES

- Phishing emails relayed through **NordVPN France exit nodes**.  
- C2 servers active for **5 days** before takedown.  
- **Open directories** exposed malware tools and payloads.  
- Hosted using **Python SimpleHTTPServer**.  
- Evidence of **code reuse** from earlier MuddyWater families like **CannonRat**.

**Tools/Techniques:**
- VPN for operational security  
- Short-lived C2 infrastructure  
- SimpleHTTP hosting  
- Reused components from older toolkits  

---

## COMBINED SUMMARY TABLE

| Phase | Objective | Tools / Techniques |
|-------|------------|-------------------|
| Initial Access | Phishing via compromised mailbox | Word macros, NordVPN |
| Execution | Loader and backdoor deployment | FakeUpdate, Phoenix v4 |
| Persistence | System and registry persistence | Winlogon Shell, Mutex, COM DLL |
| C2 | Remote control and command execution | WinHTTP, PDQ RMM, Action1 |
| Credential Theft | Browser credential exfiltration | Chromium_Stealer |
| Infrastructure | Operational cover and delivery | VPN, SimpleHTTP, code reuse |

---

## REFERENCES

1. **Infosecurity Magazine** – [MuddyWater Compromised Mailboxes](https://www.infosecurity-magazine.com/news/muddywater-compromised-mailboxes/)  
2. **Group-IB Blog** – [Unmasking MuddyWater’s New Malware Toolkit Driving International Espionage](https://www.group-ib.com/blog/muddywater-espionage/)

---

*Compiled for Threat Intelligence and Malware Reverse Engineering Training – 2025*
