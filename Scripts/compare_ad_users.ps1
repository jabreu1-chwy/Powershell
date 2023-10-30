


$users = Get-Content "C:\Users\AA-JAbreu1.001\Downloads\compare_users_to_AD.txt"
$results = @()

foreach ($user in $users) {
    $result = New-Object PSObject
    $result | Add-Member -MemberType NoteProperty -Name "Username" -Value $user
    try {
        $adUser = Get-ADUser -Identity $user -ErrorAction Stop
        if ($adUser.Enabled -eq $true) {
            $result | Add-Member -MemberType NoteProperty -Name "Status" -Value "Active"
        } else {
            $result | Add-Member -MemberType NoteProperty -Name "Status" -Value "Disabled"
        }
    } catch {
        $result | Add-Member -MemberType NoteProperty -Name "Status" -Value "Not found"
    }
    $results += $result
}

$results | Export-Csv -Path "C:\Users\AA-JAbreu1.001\Downloads\results.csv" -NoTypeInformation