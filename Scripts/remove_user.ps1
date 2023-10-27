# Define the DL and user
$DistributionList = "DL-OpsTalentAcquisition@chewy.com"
$UserToRemove = "kwardrop@chewy.com"

# Remove the user from the DL
Remove-DistributionGroupMember -Identity $DistributionList -Member $UserToRemove -Confirm:$false
