$csvFile = "/Users/jabreu1/Documents/WindowsPowerShell/Scripts/FullName.csv"
if (-not (Test-Path $csvFile)) {
    Write-Host "File not found. Exiting."
    return
}

# Import the CSV file
$users = Import-Csv $csvFile

# Loop through the users and search for email addresses
$newUsers = foreach ($user in $users) {
    # Use the Get-Recipient cmdlet to search for users with a matching full name
    $searchResults = Get-Recipient -Filter "Name -eq '$($user.FullName)'" -ResultSize 1

    # If there are no matches, create a new object with FullName and EmailAddress properties set to "No Found"
    if (-not $searchResults) {
        Write-Host "No exact match found for $($user.FullName)."
        $newUser = New-Object -TypeName PSObject
        $newUser | Add-Member -MemberType NoteProperty -Name FullName -Value $user.FullName
        $newUser | Add-Member -MemberType NoteProperty -Name EmailAddress -Value "No Exact Match"
        $newUser
    }
    # If there is exactly 1 match, create a new object with FullName and EmailAddress properties set to the email address
    else {
        $emailAddress = $searchResults.PrimarySmtpAddress
        Write-Host "$($user.FullName): $emailAddress"
        $newUser = New-Object -TypeName PSObject
        $newUser | Add-Member -MemberType NoteProperty -Name FullName -Value $user.FullName
        $newUser | Add-Member -MemberType NoteProperty -Name EmailAddress -Value $emailAddress
        $newUser
    }
}

# Export the updated CSV file
$newUsers | Export-Csv $csvFile -NoTypeInformation -UseCulture

