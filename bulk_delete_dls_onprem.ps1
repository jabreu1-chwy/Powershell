# Specify the path to the text file containing distribution list names
$listFile = "C:\Users\AA-JAbreu1.001\Documents\lists.txt"

# Read the list of distribution list names from the file
$lists = Get-Content $listFile

# Loop through each distribution list and delete it
foreach ($list in $lists) {
    try {
        $distributionList = Get-ADGroup -Filter {Name -eq $list -and GroupCategory -eq 'Distribution'}
        if ($distributionList) {
            Remove-ADGroup -Identity $distributionList.DistinguishedName -Confirm:$false
            Write-Host "Deleted distribution list: $list" -ForegroundColor Cyan
        } else {
            Write-Host "Distribution list not found: $list" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error deleting distribution list: $list" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}