# Define the target date when the users should expire
$expirationDate = Get-Date -Year 2023 -Month 08 -Day 23

# Path to the text file containing email addresses
$filePath = "C:\Users\AA-JAbreu1\Documents\users.txt"

# Read the contents of the text file
$emailAddresses = Get-Content -Path $filePath

# Loop through each email address and set the expiration date
foreach ($email in $emailAddresses) {
    # Get the user object from Active Directory based on email address
    $userObject = Get-ADUser -Filter "EmailAddress -eq '$email'"

    if ($userObject) {
        # Set the expiration date for the user
        $userObject.AccountExpirationDate = $expirationDate

        # Save the changes to Active Directory
        Set-ADUser -Instance $userObject
        Write-Host "Expiration date set for user with email: $email to $expirationDate"
    }
    else {
        Write-Host "User not found with email: $email"
    }
}
