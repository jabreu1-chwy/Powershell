Import-CSV "/Users/jabreu1/Documents/WindowsPowerShell/Scripts/UPN.csv" | ForEach-Object {  
    $UPN = $_.UPN 
    # Write-Progress -Activity "Adding $UPN to group… " 
    Add-DistributionGroupMember –Identity "DL-MCO1-ShiftReports" -Member $UPN  
    If ($?) {  
        Write-Host $UPN Successfully added -ForegroundColor Green 
    }  
    Else {  
        Write-Host $UPN - Error occurred –ForegroundColor Red  
    }  
} 