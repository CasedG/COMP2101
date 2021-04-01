""
""
"System Hardware Description" 
$systemHardwareDescription = Get-WmiObject -class win32_computersystem | fl
$systemHardwareDescription
""
""
"OS Name and Version Number"
$osNameandVersion = Get-WmiObject -class win32_operatingsystem | fl Name, Version
$osNameandVersion
""
""
"Processor Description"
$processorDescription = Get-WmiObject -class win32_processor | fl Description, NumberOfCores, L2CacheSize, L3CacheSize 
$processorDescription
""
""
"Summary of RAM"
$totalCapacity = 0

Get-WmiObject -class win32_physicalmemory |
    foreach {
        New-Object -TypeName psobject -Property @{
            Vendor = $_.manufacturer
            Description = $_.description
            "Size(MB)" = $_.capacity/1MB
            Bank = $_.banklabel
            Slot = $_.devicelocator
        }
        $totalCapacity += $_.capacity/1mb
    } |
    format-table -AutoSize Vendor,
                           Description,
                           "Size(MB)",
                           Bank,
                           Slot

"Total RAM: ${totalCapacity}MB"
""
""
""
""
"Summary of disk drives"
$diskdrives = get-ciminstance cim_diskdrive

foreach ($disk in $diskdrives) {
    $partitions = $disk | Get-CimAssociatedInstance -resultclassname CIM_diskpartition
    foreach ($partition in $partitions) {
        $logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk
        foreach ($logicaldisk in $logicaldisks) {
            New-Object -TypeName psobject -property @{Manufacturer=$disk.Manufacturer
                                                      Location=$partition.deviceid
                                                      Drive=$logicaldisk.deviceid
                                                      "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                      }
        }
    }
}
""
""
""
"Network Adapter Configuration"
get-ciminstance win32_networkadapterconfiguration | where-object ipenabled -eq "True" | format-table Description, Index, IPaddress, IPsubnet, DNSDomain, DNSHostName 
""
""
""
"Video Card Summary"
get-wmiobject -class win32_videocontroller | fl Name, Description, CurrentHorizontalResolution, CurrentVerticalResolution
$videoSummary = Get-WmiObject -class win32_videocontroller
