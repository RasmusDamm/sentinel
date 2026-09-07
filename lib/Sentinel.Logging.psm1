function Write-SentinelLog {

    param(
        [Parameter(Mandatory)]
        [ValidateSet('INFO','WARN','ERROR')]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Message
    )

    $t = Get-Date -Format 'o'

    [Console]::Error.WriteLine("$t [$Level] $Message")
}

function Write-SentinelSection {

    param(
        [Parameter(Mandatory)]
        [string]$Title
    )

    [Console]::Error.WriteLine("")
    [Console]::Error.WriteLine("=== $Title ===")
}