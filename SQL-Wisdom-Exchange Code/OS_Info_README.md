# Server Information Gathering Script

This PowerShell script collects detailed information about the system, such as operating system, hardware, network configuration, uptime, cluster status, and patch history. It can be run on any Windows machine to quickly gather and output key details about the system configuration.

## Script Overview

The script gathers the following information:

1. **Operating System Information**: Displays OS name and the last applied patch date.
2. **Server Details**:
   - Server name
   - Domain and Fully Qualified Domain Name (FQDN)
   - Server type (Physical or Virtual)
   - RAM size
   - CPU details (Sockets, Cores, Logical Processors)
3. **Uptime Information**: Shows the server's last reboot time and the uptime in days.
4. **Network Configuration**: Displays the server's IP address and DNS domain.
5. **Cluster Information**: Checks if the server is part of a cluster and displays cluster-related details (if applicable).

## Code Explanation

The script uses Windows Management Instrumentation (WMI) to gather system information and organizes it into a structured object for easy output. Key elements include:

- **Server Name**: The server's hostname.
- **Domain**: The domain the server is part of.
- **FQDN**: The fully qualified domain name.
- **RAM Size**: The total physical memory in gigabytes.
- **CPU Information**: Includes the number of sockets, cores, and logical processors.
- **Uptime**: Time since the last reboot of the server.
- **Cluster Information**: If the server is part of a cluster, details such as cluster name and IP address are shown.
- **Patch History**: The most recent patch installed on the server.

## Requirements

- PowerShell (any version that supports the `Get-WmiObject` cmdlet, generally from PowerShell 2.0 upwards).
- Failover Clustering module (for cluster information, optional).

## Instructions

1. Copy the script into a `.ps1` file.
2. Run the script in PowerShell as an administrator.
3. Review the gathered information output in the PowerShell console.

## Example Output

```plaintext
Server Name           = SERVER01
Domain                = DOMAIN01
FQDN                  = SERVER01.domain.com
IP Address            = 192.168.1.100
OS Name               = Microsoft Windows Server 2019 Datacenter
Server Type           = Physical
RAM Size (GB)         = 32.00
Sockets               = 2
Cores                 = 16
Logical Processors    = 32
Last Patch Applied    = 12/01/2024
Last Reboot Time      = 01/22/2025 08:15:00
Up Time (Days)        = 3
Cluster Name          = Standalone
Cluster IP            = N/A
