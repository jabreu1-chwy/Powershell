# Replace 'GroupName' with the actual name of the security group
$groupName = "sg-Okta-NAVEXOne"

# Replace 'Path\to\your\users.csv' with the actual path to your CSV file
$csvPath = "C:\Users\AA-JAbreu1.007\Downloads\users1.csv"


$users = Get-Content $csvPath
foreach ($user in $users) {
    # Check if the user is already a member of the group
    if (Get-ADGroupMember -Identity $groupName -Recursive | Where-Object {$_.SamAccountName -eq $user}) {
        Write-Host "$user is already a member of $groupName"
    } else {
        # Add the user to the group
        Add-ADGroupMember -Identity $groupName -Members $user
        Write-Host "Added $user to $groupName"
    }
}




