Function recreate-dl {

    <#
        .PARAMETER Group
            Name of group to recreate.
    
        .PARAMETER CreatePlaceHolder
            Create placeholder group.
            .EXAMPLE #1
                .\Recreate-DistributionGroup-org.ps1 -Group "DL-Marketing" -CreatePlaceHolder
    
        .PARAMETER Finalize
            Convert placeholder group to final group.
            .EXAMPLE #2
                .\Recreate-DistributionGroup-org.ps1 -Group "DL-Marketing" -Finalize
    #>
    [cmdletbinding()]
    
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$Group,
        [Parameter(Mandatory = $False)]
        [switch]$CreatePlaceHolder,
        [Parameter(Mandatory = $False)]
        [switch]$Finalize
    )
    
    foreach ($dl in $dls) {
        $Group = $dl.Name
        $ExportDirectory = ".\ExportedAddresses\"
        
        If ($CreatePlaceHolder.IsPresent) {
        
            If (((Get-DistributionGroup $Group -ErrorAction 'SilentlyContinue').IsValid) -eq $true) {
        
                $OldDG = Get-DistributionGroup $Group
        
                [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object { $Group = $Group.Replace($_, '_') }
                
                $OldName = [string]$OldDG.Name
                $OldDisplayName = [string]$OldDG.DisplayName
                $OldPrimarySmtpAddress = [string]$OldDG.PrimarySmtpAddress
                $OldAlias = [string]$OldDG.Alias
                $OldMembers = (Get-DistributionGroupMember $OldDG.Name).PrimarySMTPAddress
        
                If (!(Test-Path -Path $ExportDirectory )) {
                    Write-Host "  Creating Directory: $ExportDirectory"
                    New-Item -ItemType directory -Path $ExportDirectory | Out-Null
                }
        
                "EmailAddress" > "$ExportDirectory\$Group.csv"
                $OldDG.EmailAddresses >> "$ExportDirectory\$Group.csv"
                "x500:" + $OldDG.LegacyExchangeDN >> "$ExportDirectory\$Group.csv"
        
                Write-Host "  Creating Group: Migrated-$OldDisplayName"
                if ($OldDG.ManagedBy) {
                    New-DistributionGroup `
                        -Name "Migrated-$OldName" `
                        -Alias "Migrated-$OldAlias" `
                        -DisplayName "Migrated-$OldDisplayName" `
                        -ManagedBy $OldDG.ManagedBy `
                        -Members $OldMembers `
                        -PrimarySmtpAddress "Migrated-$OldPrimarySmtpAddress" | Out-Null
                }
                else {
                    New-DistributionGroup `
                        -Name "Migrated-$OldName" `
                        -Alias "Migrated-$OldAlias" `
                        -DisplayName "Migrated-$OldDisplayName" `
                        -ManagedBy  "desk@chewy.com" `
                        -Members $OldMembers `
                        -PrimarySmtpAddress "Migrated-$OldPrimarySmtpAddress" | Out-Null
                }
        
                Start-Sleep -Seconds 3
        
                Write-Host "  Setting Values For: Migrated-$OldDisplayName"
        
                Set-DistributionGroup `
                    -Identity "Migrated-$OldName" `
                    -AcceptMessagesOnlyFromSendersOrMembers $OldDG.AcceptMessagesOnlyFromSendersOrMembers `
                    -RejectMessagesFromSendersOrMembers $OldDG.RejectMessagesFromSendersOrMembers `
        
                Set-DistributionGroup `
                    -Identity "Migrated-$OldName" `
                    -AcceptMessagesOnlyFrom $OldDG.AcceptMessagesOnlyFrom `
                    -AcceptMessagesOnlyFromDLMembers $OldDG.AcceptMessagesOnlyFromDLMembers `
                    -BypassModerationFromSendersOrMembers $OldDG.BypassModerationFromSendersOrMembers `
                    -BypassNestedModerationEnabled $OldDG.BypassNestedModerationEnabled `
                    -CustomAttribute1 $OldDG.CustomAttribute1 `
                    -CustomAttribute2 $OldDG.CustomAttribute2 `
                    -CustomAttribute3 $OldDG.CustomAttribute3 `
                    -CustomAttribute4 $OldDG.CustomAttribute4 `
                    -CustomAttribute5 $OldDG.CustomAttribute5 `
                    -CustomAttribute6 $OldDG.CustomAttribute6 `
                    -CustomAttribute7 $OldDG.CustomAttribute7 `
                    -CustomAttribute8 $OldDG.CustomAttribute8 `
                    -CustomAttribute9 $OldDG.CustomAttribute9 `
                    -CustomAttribute10 $OldDG.CustomAttribute10 `
                    -CustomAttribute11 $OldDG.CustomAttribute11 `
                    -CustomAttribute12 $OldDG.CustomAttribute12 `
                    -CustomAttribute13 $OldDG.CustomAttribute13 `
                    -CustomAttribute14 $OldDG.CustomAttribute14 `
                    -CustomAttribute15 $OldDG.CustomAttribute15 `
                    -ExtensionCustomAttribute1 $OldDG.ExtensionCustomAttribute1 `
                    -ExtensionCustomAttribute2 $OldDG.ExtensionCustomAttribute2 `
                    -ExtensionCustomAttribute3 $OldDG.ExtensionCustomAttribute3 `
                    -ExtensionCustomAttribute4 $OldDG.ExtensionCustomAttribute4 `
                    -ExtensionCustomAttribute5 $OldDG.ExtensionCustomAttribute5 `
                    -GrantSendOnBehalfTo $OldDG.GrantSendOnBehalfTo `
                    -HiddenFromAddressListsEnabled $False `
                    -MailTip $OldDG.MailTip `
                    -MailTipTranslations $OldDG.MailTipTranslations `
                    -MemberDepartRestriction "Open" `
                    -MemberJoinRestriction $OldDG.MemberJoinRestriction `
                    -ModeratedBy $OldDG.ModeratedBy `
                    -ModerationEnabled $OldDG.ModerationEnabled `
                    -RejectMessagesFrom $OldDG.RejectMessagesFrom `
                    -RejectMessagesFromDLMembers $OldDG.RejectMessagesFromDLMembers `
                    -ReportToManagerEnabled $OldDG.ReportToManagerEnabled `
                    -ReportToOriginatorEnabled $OldDG.ReportToOriginatorEnabled `
                    -RequireSenderAuthenticationEnabled $OldDG.RequireSenderAuthenticationEnabled `
                    -SendModerationNotifications $OldDG.SendModerationNotifications `
                    -SendOofMessageToOriginatorEnabled $OldDG.SendOofMessageToOriginatorEnabled `
                    #-BypassSecurityGroupManagerCheck
            }                
            Else {
                Write-Host "  ERROR: The distribution group '$Group' was not found" -ForegroundColor Red
            }
        }
    
        ElseIf ($Finalize.IsPresent) {

            Write-Host "Finalizing the Process" -ForegroundColor Green
        
            $TempDG = Get-DistributionGroup "Migrated-$Group"
            $TempPrimarySmtpAddress = $TempDG.PrimarySmtpAddress
        
            [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object { $Group = $Group.Replace($_, '_') }
        
            $OldAddresses = @(Import-Csv "$ExportDirectory\$Group.csv")
            
            $NewAddresses = $OldAddresses | ForEach-Object { $_.EmailAddress.Replace("X500", "x500") }
        
            $NewDGName = $TempDG.Name.Replace("Migrated-", "")
            $NewDGDisplayName = $TempDG.DisplayName.Replace("Migrated-", "")
            $NewDGAlias = $TempDG.Alias.Replace("Migrated-", "")
            $NewPrimarySmtpAddress = ($NewAddresses | Where-Object { $_ -clike "SMTP:*" }).Replace("SMTP:", "")
        
            Set-DistributionGroup `
                -Identity $TempDG.Name `
                -Name $NewDGName `
                -Alias $NewDGAlias `
                -DisplayName $NewDGDisplayName `
                -PrimarySmtpAddress $NewPrimarySmtpAddress `
                -HiddenFromAddressListsEnabled $False `
                #-BypassSecurityGroupManagerCheck
        
            Set-DistributionGroup `
                -Identity $NewDGName `
                -EmailAddresses @{Add = $NewAddresses } `
                #-BypassSecurityGroupManagerCheck
        
            Set-DistributionGroup `
                -Identity $NewDGName `
                -EmailAddresses @{Remove = $TempPrimarySmtpAddress } `
                #-BypassSecurityGroupManagerCheck
                    
        }
        Else {
            Write-Host "  ERROR: No options selected, please use '-CreatePlaceHolder' or '-Finalize'" -ForegroundColor Red
            Write-Host
        }
    }
}



# $CheckGroupInterval = 600  # Check group presence every 10 minutes
# $GroupFound = $false

# # Loop until the group is found or until a specified timeout is reached
# $TimeoutMinutes = 1800# Maximum timeout in minutes
# $Timeout = (Get-Date).AddMinutes($TimeoutMinutes)
# while (!$GroupFound -and (Get-Date) -lt $Timeout) {
#     $TempDG = Get-DistributionGroup "$Group" -ErrorAction SilentlyContinue
#     if ($null -ne $TempDG) {
#         $GroupFound = $true
#     }
#     else {
#         Write-Host "Group was found. Retrying in 10 minutes..."
#         Start-Sleep -Seconds $CheckGroupInterval
#     }
# }



    
# if ($GroupFound) {
    
#     $TempDG = Get-DistributionGroup "Migrated-$Group"
#     $TempPrimarySmtpAddress = $TempDG.PrimarySmtpAddress
    
#     [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object { $Group = $Group.Replace($_, '_') }
    
#     $OldAddresses = @(Import-Csv "$ExportDirectory\$Group.csv")
        
#     $NewAddresses = $OldAddresses | ForEach-Object { $_.EmailAddress.Replace("X500", "x500") }
    
#     $NewDGName = $TempDG.Name.Replace("Migrated-", "")
#     $NewDGDisplayName = $TempDG.DisplayName.Replace("Migrated-", "")
#     $NewDGAlias = $TempDG.Alias.Replace("Migrated-", "")
#     $NewPrimarySmtpAddress = ($NewAddresses | Where-Object { $_ -clike "SMTP:*" }).Replace("SMTP:", "")
    
#     Set-DistributionGroup `
#         -Identity $TempDG.Name `
#         -Name $NewDGName `
#         -Alias $NewDGAlias `
#         -DisplayName $NewDGDisplayName `
#         -PrimarySmtpAddress $NewPrimarySmtpAddress `
#         -HiddenFromAddressListsEnabled $False `
#         #-BypassSecurityGroupManagerCheck
    
#     Set-DistributionGroup `
#         -Identity $NewDGName `
#         -EmailAddresses @{Add = $NewAddresses } `
#         #-BypassSecurityGroupManagerCheck
    
#     Set-DistributionGroup `
#         -Identity $NewDGName `
#         -EmailAddresses @{Remove = $TempPrimarySmtpAddress } `
#         #-BypassSecurityGroupManagerCheck
                
# }
# Else {
#     Write-Host "  ERROR: No options selected, please use '-CreatePlaceHolder' or '-Finalize'" -ForegroundColor Red
#     Write-Host
# }
