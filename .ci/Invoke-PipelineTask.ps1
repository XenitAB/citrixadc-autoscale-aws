<#
.Synopsis
    Script to deploy services to Kubernetes either using local computer or Azure DevOps.
.DESCRIPTION
    Build:
        Invoke-PipelineTask.ps1 -build
    Deploy:
        Invoke-PipelineTask.ps1 -deploy
.NOTES
    Name: Invoke-PipelineTask.ps1
    Author: Simon Gottschlag
    Date Created: 2019-08-07
    Version History:
        2019-08-07 - Simon Gottschlag
            Initial Creation


    Xenit AB
#>

[cmdletbinding(DefaultParameterSetName = 'build')]
Param(
    [Parameter(Mandatory = $true, ParameterSetName = 'build')]
    [switch]$build,
    [Parameter(Mandatory = $true, ParameterSetName = 'deploy')]
    [switch]$deploy
)

Begin {
    $ErrorActionPreference = "Stop"

    # Function to retrun error code correctly from binaries
    function Invoke-Call {
        param (
            [scriptblock]$ScriptBlock,
            [string]$ErrorAction = $ErrorActionPreference
        )
        & @ScriptBlock
        if (($lastexitcode -ne 0) -and $ErrorAction -eq "Stop") {
            exit $lastexitcode
        }
    }

    function Log-Message {
        Param(
            [string]$message,
            [switch]$header
        )

        if ($header) {
            Write-Output ""
            Write-Output "=============================================================================="
        } else {
            Write-Output ""
            Write-Output "---"
        }
        Write-Output $message
        if ($header) {
            Write-Output "=============================================================================="
            Write-Output ""
        } else {
            Write-Output "---"
            Write-Output ""
        }
    }
}
Process {
    $tfPath = "$($PSScriptRoot)/../terraform/"
    $tfBin = $(Get-Command terraform -ErrorAction Stop)
    $ENV:TF_VAR_region = $($ENV:REGION)
    $ENV:TF_VAR_externalDnsZone = $($ENV:EXTERNALDNSZONE)
    $ENV:TF_VAR_citrixExternalId = $($ENV:citrixExternalIdVariable)
    $ENV:TF_VAR_deployPublicSshKey = $($ENV:deployPublicSshKeyVariable)
    $ENV:TF_VAR_externalManagementIp = $($ENV:externalManagementIpVariable)
    Set-Location -Path $tfPath -ErrorAction Stop

    switch ($PSCmdlet.ParameterSetName) {
        'build' {
            Log-Message -message "START: Build" -header
            try {
                Log-Message -message "START: terraform init"
                Invoke-Call ([ScriptBlock]::Create("$tfBin init -input=false -backend-config `"bucket=$($ENV:S3BUCKETNAME)`" -backend-config `"key=tfstate/$($ENV:ENVIRONMENT)/$($ENV:COMMONNAME).tfstate`" -backend-config `"region=$($ENV:REGION)`""))
                Log-Message -message "END: terraform init"

                Log-Message -message "START: terraform plan"
                Invoke-Call ([ScriptBlock]::Create("$tfBin plan -input=false"))
                Log-Message -message "END: terraform plan"

                Log-Message -message "START: terraform validate"
                Invoke-Call ([ScriptBlock]::Create("$tfBin validate"))
                Log-Message -message "END: terraform validate"
            } catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Build" -header
        }
        'deploy' {
            Log-Message -message "START: Deploy" -header
            try {
                Log-Message -message "START: terraform init"
                Invoke-Call ([ScriptBlock]::Create("$tfBin init -input=false -backend-config `"bucket=$($ENV:S3BUCKETNAME)`" -backend-config `"key=tfstate/$($ENV:ENVIRONMENT)/$($ENV:COMMONNAME).tfstate`" -backend-config `"region=$($ENV:REGION)`""))
                Log-Message -message "END: terraform init"

                Log-Message -message "START: terraform apply"
                Invoke-Call ([ScriptBlock]::Create("$tfBin apply -input=false -auto-approve"))
                Log-Message -message "END: terraform init"
            } catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Error "Message: $ErrorMessage`r`nItem: $FailedItem"
                exit 1
            }
            Log-Message -message "END: Deploy" -header
        }
        default {
            Write-Error "No options chosen."
            exit 1
        }
    }
}
End {
    
}