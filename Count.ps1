$ErrorActionPreference = 'Stop'

if ($args.Count -lt 1) {
    Write-Error "brug: $($MyInvocation.MyCommand.Name) FIL"
    exit 1
}

$file = $args[0]

if (Test-Path $file) {
    $lines = (Get-Content $file).Count
    Write-Output "$file har $lines linjer"
    exit 0
}
else {
    Write-Error "findes ikke: $file"
    exit 1
}