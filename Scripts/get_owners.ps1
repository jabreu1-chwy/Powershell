# Replace <DL Name> with the name of the distribution group you want to check
$dlName = "DL-BNA1-Inbound@chewy.com"

# Get the distribution group object from Exchange
$dlObj = Get-DistributionGroup -Identity $dlName -ErrorAction SilentlyContinue
if ($null -eq $dlObj) {
    Write-Host "Distribution group '$dlName' not found in Exchange." -ForegroundColor Yellow
}
else {
    # Get the owner of the distribution group
    $owner = $dlObj.ManagedBy
    # Get the SMTP address of the owner
    $ownerEmail = Get-Recipient -Identity $owner | Select-Object 'Email address'

    # Output the name of the owner to the console
    Write-Host "The owner of distribution group '$dlName' is '$owner' - $ownerEmail." -ForegroundColor Green
}


