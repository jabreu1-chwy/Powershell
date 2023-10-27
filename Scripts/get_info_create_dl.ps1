Function Create-ExchangeOnlineDistributionGroup {
    # Prompt for on-premises distribution group name
    $onPremGroupName = Read-Host "Enter the name of the on-premises distribution group:"
    # Get on-premises distribution group members' email addresses
    $onPremMembers = Get-DistributionGroupMember -Identity $onPremGroupName | Select-Object -ExpandProperty PrimarySmtpAddress
    # Get on-premises distribution group ManagedBy
    $onPremManagedBy = (Get-DistributionGroup -Identity $onPremGroupName).ManagedBy
    # Get on-premises distribution group PremLegacyExchangeDN
    $onPremLegacyExchangeDN = Get-DistributionGroup -Identity $onPremGroupName | Select-Object -ExpandProperty LegacyExchangeDN
    # Prompt for new Exchange Online distribution group name
    $newGroupName = Read-Host "Enter the name of the new Exchange Online distribution group name:"
    # Prompt for new Exchange Online distribution group email address
    $newGroupEmail = Read-Host "Enter the name of the new Exchange Online distribution group email:"
    # Create new distribution group in Exchange Online
    if ($onPremManagedBy) {
        New-DistributionGroup -Name $newGroupName -PrimarySmtpAddress $newGroupEmail -ManagedBy $onPremManagedBy
    }
    else {
        New-DistributionGroup -Name $newGroupName -PrimarySmtpAddress $newGroupEmail
    }
    # Add on-premises distribution group members as members of new Exchange Online group
    Add-DistributionGroupMember -Identity $newGroupName -Member $onPremMembers
    
    Set-DistributionGroup -Identity $newGroupName -EmailAddresses X500:$onPremLegacyExchangeDN 
}
 
