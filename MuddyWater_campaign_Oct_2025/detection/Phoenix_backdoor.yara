rule Phoenix_Backdoor_Detection
{
    meta:
        author = "Abhijit Mohanta"
        description = "Detects Phoenix backdoor artifacts"
        date = "2025-10-27"
 
    strings:
        $filename = "sysprocupdate.exe" nocase
        $pdb_path = "phoenix.pdb" nocase
        $reg_key  = "CurrentVersion\\Winlogon" nocase

    condition:
        any of them
}
