# Set the name of the security group
$groupName = "SG-Okta-Zeus-PRD-CAT-MGR"

# Set the output CSV file path
$outputFile = "C:\Users\aa-jabreu1\downloads\SG-Okta-Zeus-PRD-CAT-MGR.csv"

# Get the group members
$members = Get-ADGroupMember -Identity $groupName

# Create an empty array to store member details
$memberDetails = @()

# Retrieve member details and add them to the array
foreach ($member in $members) {
    if ($member.ObjectClass -eq "User") {
        # Member is a user
        $user = Get-ADUser -Identity $member.SamAccountName -Properties DisplayName, EmailAddress, SamAccountName
        $memberDetails += [PSCustomObject]@{
            Name = $user.DisplayName
            Email = $user.EmailAddress
            Username = $user.SamAccountName  # Assuming SAML name is stored in SamAccountName
        }
    }
    elseif ($member.ObjectClass -eq "Group") {
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
$memberDetails | Export-Csv -Path $outputFile -NoTypeInformation

# Output the file path
Write-Output "Member details exported to: $outputFile"
