# Set the name of the security group
$groupName = "SG-OKTA-EPBCS-Prod"

$outputCsvFile = "C:\Users\AA-JAbreu1\Downloads\file1.csv"
$inputCsvFile = "C:\Users\AA-JAbreu1\Downloads\input.csv"  # Define the input CSV file path

# Rest of your script...

# Export the member details to a CSV file
$memberDetails | Export-Csv -Path $inputCsvFile -NoTypeInformation

# Retrieve member details and add them to the array
foreach ($member in $members) {
    if ($member.ObjectClass -eq "User") {
        # Member is a user
        $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName, EmailAddress, SamAccountName
        $memberDetails += [PSCustomObject]@{
            Name = $user.DisplayName
            Email = $user.EmailAddress
            Username = $user.SamAccountName
        }
    } elseif ($member.ObjectClass -eq "Group") {
        # Member is a nested group
        $group = Get-ADGroup -Identity $member.SamAccountName -Properties Description
        $memberDetails += [PSCustomObject]@{
            Name = $group.Name
            Email = ""
            Username = ""
        }
    }
}

# Export the member details to a CSV file
$memberDetails | Export-Csv -Path $inputCsvFile -NoTypeInformation

# Loop through the users in the CSV file and check their status in Active Directory
$users = Import-Csv $inputCsvFile

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
$users | Export-Csv $outputCsvFile -NoTypeInformation
Write-Host "User status has been added to the CSV file: $outputCsvFile"
