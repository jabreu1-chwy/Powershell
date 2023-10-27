
# Specify the DL name
$DLName = "DL - Merch_CMTeam"

# Get the DL members
$DLMembers = Get-DistributionGroupMember -Identity $DLName | Select-Object FirstName, LastName, PrimarySmtpAddress

# Export DL members to a CSV file
$DLMembers | Export-Csv -Path "cmteam.csv" -NoTypeInformation

