$csv = Import-Csv -Path "/Users/jabreu1/Documents/WindowsPowerShell/Scripts/verify_dl.csv" -Header "Column1"
$results = @()

foreach ($row in $csv) {
    $email = $row.Column1
    $isDL = $null
    
    # Check for DL in Exchange Online
    try {
        $isDL = Get-DistributionGroup -Filter "Name -like '$email'" -ResultSize 1000 -ErrorAction Stop
        if ($isDL) {
            $row | Add-Member -MemberType NoteProperty -Name "Verification" -Value "Verified"
            continue
        }
    }
    catch {
        # Ignore errors and move on to the next check
    }

    # Check if it's a regular mailbox
    try {
        Get-Mailbox -Identity $email -ErrorAction Stop
        $row | Add-Member -MemberType NoteProperty -Name "Verification" -Value "User mailbox"
        continue
    }
    catch {
        # Ignore errors and move on to the next check
    }

    # Check for DL/SG in Active Directory
    $adGroup = Get-ADGroup -Filter { Name -like $email } -Properties GroupCategory -ErrorAction SilentlyContinue
    if ($adGroup) {
        if ($adGroup.GroupCategory -eq "Distribution") {
            $row | Add-Member -MemberType NoteProperty -Name "Verification" -Value "Active Directory Distribution list"
        }
        elseif ($adGroup.GroupCategory -eq "Security") {
            $row | Add-Member -MemberType NoteProperty -Name "Verification" -Value "Active Directory Security group"
        }
        continue
    }
    
    $row | Add-Member -MemberType NoteProperty -Name "Verification" -Value "Not found"
    $results += $row
}


$results | Export-Csv -Path "/Users/jabreu1/Documents/WindowsPowerShell/Scripts/verify_dl.csv" -NoTypeInformation
