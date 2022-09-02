param (
    [Parameter(Position = 0, HelpMessage = "create docker containers")]
    [string[]]$containers,

    [Parameter(Mandatory, HelpMessage = "App path")]
    [string]$appPath
)

# import helpers
. ".\tmp\paths.ps1"
. ".\tmp\utils.ps1"

# format inputs
$config = @{
    target = @{
        name = Split-Path $appPath -Leaf
        path = resolveTarget $appPath
    }
}

if (-not $config.target.path) {
    Write-Host "cda: Path does not exist: " $appPath
    exit 1
}

# construct an image of the directory tree
$config.dirTree = buildDirTree


# construct the container configuration interfaces as per user
# request
if ($containers) {
    . ".\tmp\buildContainerConfs.ps1"
    Write-host "Entering Containers"
    $config.containers = buildContainerConfigurators $config $containers
} 

inspectObj $config "target"