# PowerShell wrapper for Ruby CLI script
param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$InputObject
)

begin {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $inputData = ""
}

process {
    $inputData += $InputObject
}

end {
    if ($inputData) {
        $inputData | & ruby "$scriptDir/cli"
    } else {
        & ruby "$scriptDir/cli"
    }
}
