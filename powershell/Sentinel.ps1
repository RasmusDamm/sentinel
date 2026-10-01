#!/usr/bin/env pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $PSCommandPath
Import-Module "$here/Sentinel.Logging.psm1"

function Get-SentinelUsers {
    Write-SentinelSection -Title "Users"
    Write-SentinelLog -Message "Collecting users"

    Get-LocalUser |
        Where-Object Enabled |
        Select-Object -ExpandProperty Name
}

function Get-SentinelAdmins {
    Write-SentinelSection -Title "Admins"

    try {
        Get-LocalGroupMember -Group 'Administrators' |
            Select-Object -ExpandProperty Name
    }
    catch {
        Write-SentinelLog -Level WARN -Message "no group"
    }
}

function Get-SentinelServices {
    Write-SentinelSection -Title "Services"

    Get-Service |
        Where-Object Status -eq 'Running' |
        Select-Object -ExpandProperty Name
}

function Get-SentinelPorts {
    Write-SentinelSection -Title "Listening ports"

    Get-NetTCPConnection -State Listen |
        ForEach-Object {
            $p = Get-Process -Id $_.OwningProcess `
                -ErrorAction SilentlyContinue

            "$($_.LocalPort) $($p.ProcessName)"
        }
}

function Export-Report {
    Write-SentinelSection -Title "Create Report"
    Write-SentinelLog -Level INFO -Message "Finding all failed logins"

    $lines = @(Get-Content -LiteralPath $Path)
    $failed = @($lines | Where-Object {
        $_ -cmatch '^\S+\s+LOGIN_FAILED(?:\s|$)'
    })

    $report = [PSCustomObject]@{
        totalLines = $lines.Count
        failed_logins = $failed.Count
    }

    $report | ConvertTo-Json | Set-Content 'rapport.json'
}

function Invoke-SentinelMain {
    Get-SentinelUsers
    Get-SentinelServices
    Get-SentinelPorts
    Get-SentinelAdmins
    Export-Report

    Write-SentinelLog -Message "Sentinel complete"
}

Invoke-SentinelMain