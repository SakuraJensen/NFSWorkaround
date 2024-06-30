# Define the NFS share and drive letter
# Sakura Jensen 2024
$driveLetter = "Z:"
$nfsShare = "\\192.168.4.50\mnt\NAS"

# Test if NAS is available
function Test-NetworkConnection {
    param (
        [string]$IPAddress = "192.168.4.50"
    )
    try {
        $pingResult = Test-Connection -ComputerName $IPAddress -Count 1 -Quiet
        return $pingResult
    } catch {
        return $false
    }
}

# Disconnect NFS
function Disconnect-NFSShare {
    param (
        [string]$DriveLetter
    )
    if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) {
        net use $DriveLetter /delete /y
        Write-Host "Disconnected drive $DriveLetter"
    } else {
        Write-Host "Drive $DriveLetter is not connected"
    }
}

# Connect NFS
function Connect-NFSShare {
    param (
        [string]$DriveLetter,
        [string]$NFSShare
    )
    if (-not (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue)) {
        net use $DriveLetter $NFSShare /persistent:no
        Write-Host "Connected drive $DriveLetter to $NFSShare"
    } else {
        Write-Host "Drive $DriveLetter is already connected"
    }
}

if (Test-NetworkConnection) {
    Connect-NFSShare -DriveLetter $driveLetter -NFSShare $nfsShare
} else {
    Disconnect-NFSShare -DriveLetter $driveLetter
}
