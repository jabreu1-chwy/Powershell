# Collect DL Info
param (
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$PrimarySmtpAddress,
    [Parameter(Mandatory = $false)]
    [string[]]$ManagedBy = (Read-Host "Enter the DL owners email, seperate with commas for multiple owners").Split(","),
    [Parameter(Mandatory = $false)]
    [string]$CsvFilePath = (Read-Host "Enter the path of the CSV file or press Enter to skip")
)

# Create the distribution list
if ($ManagedBy) {
    New-DistributionGroup -Name $Name -PrimarySmtpAddress $PrimarySmtpAddress -ManagedBy $ManagedBy
}
else {
    New-DistributionGroup -Name $Name -PrimarySmtpAddress $PrimarySmtpAddress
}


# 5 Second sleep buffer
Start-Sleep -Seconds 5

# Import users from csv if path provided
if ($CsvFilePath) {
    $users = Import-Csv $CsvFilePath
    foreach ($user in $users) {
        Add-DistributionGroupMember -Identity $Name -Member $user.Email
    }
    Write-Host "Users successfully added to distribution list." -ForegroundColor Green
}
else {
    Write-Host "No CSV file path provided. Only creating distribution list." -ForegroundColor Red
}

#Path - /Users/jabreu1/Documents/WindowsPowerShell/Scripts/email.csv