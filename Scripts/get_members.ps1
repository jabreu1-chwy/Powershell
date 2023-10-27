
# Specify the DL name
$DLName = "DL-PHR_Operations"

# Get the DL members
$DLMembers = Get-DistributionGroupMember -Identity $DLName | Select-Object FirstName, LastName, PrimarySmtpAddress

# Export DL members to a CSV file
$DLMembers | Export-Csv -Path "DL-PHR_Operations.csv" -NoTypeInformation

