# Specify the user's SamAccountName or UserPrincipalName
$userIdentity = Read-Host "Enter the SamAccountName or UserPrincipalName of the user"

# Connect to Active Directory
Import-Module ActiveDirectory

# Get the user object
$user = Get-ADUser -Identity $userIdentity -Properties MemberOf

# Retrieve the group memberships
$groupMemberships = $user.MemberOf | Get-ADGroup

# Display the group memberships
Write-Host "Group Memberships for user: $($user.SamAccountName)"
$groupMemberships | Select-Object Name | Sort-Object Name | Format-Table
