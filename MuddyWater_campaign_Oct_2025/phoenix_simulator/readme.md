# sysprocupdate.exe Binary Description

## Key Functionality

1. **Mutex Creation**
   - Creates a system-wide mutex named "sysprocupdate.exe"
   - Ensures only one instance of the program runs at a time
   - Automatically exits if another instance is detected

2. **Self-Replication**
   - Copies its own executable to C:\ProgramData\sysprocupdate.exe
   - Creates the ProgramData directory if it doesn't exist
   - Uses GetModuleFileNameW API to locate its current path

3. **Registry Persistence**
   - Modifies HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
   - Sets the "Shell" value to "explorer.exe,C:\ProgramData\sysprocupdate.exe"
   - Ensures automatic execution during user logon

4. **Debug Information**
   - PDB file: phoenix.pdb
   - Located at: C:\Users\win10\Desktop\phoenixV4\phoenixV3\phoenixV2\x64\Debug\phoenix.pdb
   - Contains debugging symbols for development and analysis
5. **Collect system Information**
   - Computer name
   - Domain or workgroup
   - Windows version
   - Current username
