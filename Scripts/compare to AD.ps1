$csvFile = "C:\Users\aa-jabreu1\downloads\sg-okta-oci-finance.csv"
$outputFile = "C:\Users\AA-JAbreu1\Downloads\test.csv"

if (-not (Test-Path $csvFile)) {
    Write-Host "CSV file not found. Exiting."
    return
}

# Import the CSV file
$users = Import-Csv $csvFile

# Loop through the users and check their status in Active Directory
foreach ($user in $users) {
    $username = $user.Username

    # Use the Get-ADUser cmdlet to retrieve the user
    $adUser = Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue

    if ($adUser) {
        # User found in Active Directory
        if ($adUser.Enabled) {
            $status = "Active"
        } else {
            $status = "Disabled"
        }
    } else {
        # User not found in Active Directory
        $status = "Not Found"
    }

    # Add the "Status" property to the user object
    $user | Add-Member -MemberType NoteProperty -Name "Status" -Value $status
}

# Export the updated CSV file with the "Status" column
$users | Export-Csv $outputFile -NoTypeInformation
Write-Host "User status has been added to the CSV file: $outputFile"
