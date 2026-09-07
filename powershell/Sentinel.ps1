#!/usr/bin/env pwsh

$ErrorActionPreference = 'Stop'

$dir = Split-Path -Parent $PSCommandPath

Import-Module "$dir/../lib/Sentinel.Logging.psm1" -Force


function Get-SentinelUsers {

    Write-SentinelSection -Title "Users"

    Get-LocalUser |
        Where-Object Enabled -eq $true |
        Select-Object -ExpandProperty Name

}function Get-SentinelUsers {

    Write-SentinelLog -Level INFO -Message "Collecting users"

    Write-SentinelSection -Title "Users"

    Get-LocalUser |
        Where-Object Enabled -eq $true |
        Select-Object -ExpandProperty Name

}
function Get-SentinelServices {

    Write-SentinelLog -Level INFO -Message "Collecting services"

    Write-SentinelSection -Title "Services"

    Get-Service -ErrorAction SilentlyContinue |
        Where-Object Status -eq Running

}


function Get-SentinelPorts {

    Write-SentinelLog -Level INFO -Message "Collecting listening TCP ports"

    Write-SentinelSection -Title "Listening TCP ports"

    Get-NetTCPConnection -State Listen

}


function Get-SentinelSudoMembers {

    Write-SentinelLog -Level INFO -Message "Collecting sudo members"

    Write-SentinelSection -Title "Sudo members"

    Get-LocalGroupMember Administratorer

}


function Invoke-SentinelMain {

    Get-SentinelUsers

    Get-SentinelServices

    Get-SentinelPorts

    Get-SentinelSudoMembers

}


Invoke-SentinelMain