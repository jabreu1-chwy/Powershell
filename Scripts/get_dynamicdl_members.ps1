$DynamicDlVariable = Get-DynamicDistributionGroup -Identity "Enter DL Name Here"
$exportPATH = "\path\to\export\here"
Get-Recipient -ResultSize Unlimited -RecipientPreviewFilter ($DynamicDlVariable.RecipientFilter) | Export-csv /$exportPATH