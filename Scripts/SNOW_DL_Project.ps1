Connect-ExchangeOnline

$dl_name = "DL-address@chewy.com"
$user_to_add = "user_email@chewy.com"

$dlExists = Get-DistributionGroup -Identity $dl_name

if ($dlExists) {
    $userExists = Get-Recipient -Filter "PrimarySmtpAddress -eq '$user_to_add'"

    if ($userExists) {
        Add-DistributionGroupMember -Identity $dl_name -Member $user_to_add

        if ($?) {
            Write-Host "$user_to_add Successfully added to $dl_name" -ForegroundColor Green
        } else {
            Write-Host "Error occurred when adding $user_to_add to $dl_name" -ForegroundColor Red
        }
    } else {
        Write-Host "Email address $user_to_add does not exist." -ForegroundColor Red
    }
} else {
    Write-Host "Distribution list $dl_name does not exist." -ForegroundColor Red
}
