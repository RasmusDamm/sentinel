function Write-SentinelLog {

    param(
        [Parameter(Mandatory)]
        [ValidateSet('INFO','WARN','ERROR')]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message
    )

    $t = Get-Date -Format 'o'

    Write-Host "$t [$Level] $Message"
}

function Write-SentinelSection {

    param(
        [Parameter(Mandatory)]
        [string]$Title
    )

    Write-Host "`n=== $Title ==="
}