# Collect DL Info
param (
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$PrimarySmtpAddress,
    [Parameter(Mandatory = $false)]
    [string[]]$ManagedBy = (Read-Host "Enter the DL owners email, seperate with commas for multiple owners").Split(","),
    [Parameter(Mandatory = $false)]
    [string]$CsvFilePath = ("/Users/jabreu1/Documents/WindowsPowerShell/Scripts/email.csv")
)

# Create the distribution list
if ($ManagedBy) {
    New-DistributionGroup -Name $Name -PrimarySmtpAddress $PrimarySmtpAddress -ManagedBy $ManagedBy -RequireSenderAuthenticationEnabled $false
}
else {
    New-DistributionGroup -Name $Name -PrimarySmtpAddress $PrimarySmtpAddress -RequireSenderAuthenticationEnabled $false
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