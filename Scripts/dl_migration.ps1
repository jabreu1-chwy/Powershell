

$dirsyncedDLs = Get-DistributionGroup -filter { isDirSynced -eq $true -and GroupType -eq "Universal" } -ResultSize unlimited
$dirsyncedDLs | Select-Object ManagedBy, Description, Name, LegacyExchangeDN, PrimarySmtpAddress, HiddenFromAddressListsEnabled | export-csv -path /Users/jabreu1/Documents/WindowsPowerShell/on_prem_dl_list.csv


