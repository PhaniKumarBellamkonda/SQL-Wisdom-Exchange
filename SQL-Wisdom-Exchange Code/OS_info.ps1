# Gather information using WMI and other system methods
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$networkConfig = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
$patchHistory = Get-WmiObject -Class Win32_QuickFixEngineering | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1
$uptime = (Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime($osInfo.LastBootUpTime)

# Server Name and Domain
$serverName = $env:COMPUTERNAME
$domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain

# FQDN
$fqdn = $env:COMPUTERNAME + "." + (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }).DNSDomain

# IP Address
$ipAddress = $networkConfig.IPAddress[0]

# OS Name
$osName = $osInfo.Caption

# Server Type (Physical or Virtual)
$serverType = if ($computerSystem.Model -match "Virtual") { "Virtual" } else { "Physical" }

# RAM Size in GB
$ramSizeGB = [math]::round($computerSystem.TotalPhysicalMemory / 1GB, 2)

# CPU Information (Sockets, Cores, Logical Processors)
$sockets = $computerSystem.NumberOfProcessors
$cores = (Get-WmiObject -Class Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum
$logicalProcessors = $computerSystem.NumberOfLogicalProcessors

# Last Patching Applied Date
$lastPatchDate = if ($patchHistory.InstalledOn) { $patchHistory.InstalledOn } else { "No patch history found" }

# Last Reboot Time (Up Time)
$lastReboot = $osInfo.LastBootUpTime
$upTime = $uptime.Days

# Cluster Information (Using FailoverClusters module)
$clusterInfo = if (Get-Command Get-Cluster -ErrorAction SilentlyContinue) {
    # Check if the system is part of a cluster
    try {
        $cluster = Get-Cluster
        $clusterName = $cluster.Name
        $clusterIP = (Get-ClusterNetwork | Select-Object -First 1).Address
        [PSCustomObject]@{
            ClusterName = $clusterName
            ClusterIP = $clusterIP
        }
    } catch {
        # Not part of a cluster
        [PSCustomObject]@{
            ClusterName = "Standalone"
            ClusterIP = "N/A"
        }
    }
} else {
    # FailoverClusters module is not available, treat as standalone
    [PSCustomObject]@{
        ClusterName = "Standalone"
        ClusterIP = "N/A"
    }
}

# Output the gathered information
[PSCustomObject]@{
    "Server Name"          = $serverName
    "Domain"               = $domain
    "FQDN"                 = $fqdn
    "IP Address"           = $ipAddress
    "OS Name"              = $osName
    "Server Type"          = $serverType
    "RAM Size (GB)"        = $ramSizeGB
    "Sockets"              = $sockets
    "Cores"                = $cores
    "Logical Processors"   = $logicalProcessors
    "Last Patch Applied"   = $lastPatchDate
    "Last Reboot Time"     = $lastReboot
    "Up Time (Days)"       = $upTime
    "Cluster Name"         = $clusterInfo.ClusterName
    "Cluster IP"           = $clusterInfo.ClusterIP
}
