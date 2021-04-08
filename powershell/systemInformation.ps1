""
""
""
function systemHardware {
    "System Hardware Description" 
    $systemHardwareDescription = Get-WmiObject -class win32_computersystem | 
        foreach {
            New-Object -TypeName psobject -Property @{
                Domain = $_.domain
                Manufacturer = $_.manufacturer
                Model = $_.model
                Name = $_.name
                PrimaryOwnerName=$_.primaryownername
                "TotalPhysicalMemory(MB)"=$_.totalphysicalmemory/1mb -as [float]
                }
            } |
    fl Domain,
        Manufacturer,
        Model,
        Name,
        PrimaryOwnerName,
        "TotalPhysicalMemory(MB)"
        
    $systemHardwareDescription
    }
systemHardware
""
""

function osNameVersion {
    "OS Name and Version Number"
    $osNameandVersion = Get-WmiObject -class win32_operatingsystem |
        foreach {
            new-object -TypeName psobject -Property @{
                Name = ($_.name).substring(0, 20) 
                Version = $_.version
                }
            } |
    fl Name, Version
    $osNameandVersion
    }
osNameVersion
""
""

function processorDescription {
    "Processor Description"
    $processorDescription = Get-WmiObject -class win32_processor |
        foreach {
            new-object -TypeName psobject -Property @{
                Description = switch ($_.description) {
                    $null {
                        "Data Unavailable"
                        }
                    default {
                        $_
                        }
                    }
                NumberOfCores = switch ($_.NumberOfCores) {
                      $null {
                      "Data Unavailable"
                      }
                      default {
                        $_
                        }
                    }
                L1CacheSize = switch ($_.L1CacheSize) {
                    $null {
                        "Data Unavailable"
                        }
                    default {
                       $_/1mb
                       }
                   }  
                L2CacheSize = switch ($_.L2CacheSize) {
                    $null {
                        "Data Unavailable"
                        }
                    default {
                       $_/1mb
                       }
                   }            
                L3CacheSize = switch ($_.L3CacheSize) {
                    $null {
                        "data unavailable"
                        }
                     default {
                        $_/1mb
                        }
                    }
            }
        } |   
        fl Description, 
           NumberOfCores,
           L1CacheSize, 
           L2CacheSize, 
           L3CacheSize 
    $processorDescription
#just for self - add switch commands to every property value to determine if empty or not 
#
#
#
#
    }
processorDescription
""
""

function summaryRAM {
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
    }
summaryRAM
""
""
""
""

function diskDrives {
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
    }
diskDrives
""
""
""

function networkAdapter {
    "Network Adapter Configuration"
    get-ciminstance win32_networkadapterconfiguration | where-object ipenabled -eq "True" | format-table Description, Index, IPaddress, IPsubnet, DNSDomain, DNSHostName 
    }
networkAdapter
""
""
""
function videoCard {
    "Video Card Summary"
    get-wmiobject -class win32_videocontroller | fl Name, Description
    $videoSummary = Get-WmiObject -class win32_videocontroller 
    $horizontal = ($videoSummary).CurrentHorizontalResolution
    $vertical = ($videoSummary).CurrentVerticalResolution
    "Current screen resolution is $horizontal pixels by $vertical pixels"
    ""
    ""
    }
    
videoCard

