$DLNames = "dl-dbsmssqlservicesnon-prod@chewy.com"


$filepath = "/Users/jabreu1/Documents/WindowsPowerShell/Scripts/members-export.csv"

# Get the members of the distribution list
$Members = Get-DistributionGroupMember -Identity $DistributionListName

# Append the members of the distribution list to a CSV file without header and quotes
foreach ($DistributionListName in $DLNames) {
    # Get the members of the distribution list
    $Members = Get-DistributionGroupMember -Identity $DistributionListName

    # Append the members of the distribution list to a CSV file without header and quotes
    $Members | Where-Object { $_.PrimarySmtpAddress } | Select-Object @{Name = "Email"; Expression = { $_.PrimarySmtpAddress } } | ConvertTo-Csv -NoTypeInformation | ForEach-Object { $_ -replace '"', '' } | Select-Object -Skip 1 | Out-File -FilePath $filepath -Append
}