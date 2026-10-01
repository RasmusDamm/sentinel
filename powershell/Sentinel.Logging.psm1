function Write-SentinelLog {
    param(
        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO',

        [Parameter(Mandatory)]
        [string]$Message
    )

    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    [Console]::Error.WriteLine("[$ts] [$Level] $Message")
}

function Write-SentinelSection {
    param(
        [Parameter(Mandatory)]
        [string]$Title
    )

    [Console]::Error.WriteLine("")
    [Console]::Error.WriteLine("=== $Title ===")
}

Export-ModuleMember -Function Write-SentinelLog, Write-SentinelSection