"Hole RAW Daten"
[String]$empfangsname = Get-WmiObject -class win32_processor -Property  "Name" | Select-Object -Property "Name"
[String]$empfangscores = Get-WmiObject -class win32_processor -Property  "numberOfCores" | Select-Object -Property "numberOfCores"
[String]$empfangslcores = Get-WmiObject -class win32_processor -Property  "NumberOfLogicalProcessors" | Select-Object -Property "NumberOfLogicalProcessors"
[String]$empfangsspeed = Get-WmiObject -class win32_processor -Property  "maxclockspeed" | Select-Object -Property "maxclockspeed"
[String]$empfangshersteller = Get-WmiObject -class Win32_BIOS | Select Manufacturer
[String]$empfangsseriennummer = Get-WmiObject -class Win32_BIOS | Select SerialNumber
[String]$empfangsram = Get-wmiobject -class Win32_ComputerSystem | Select TotalPhysicalMemory
[String]$empfangsramtyp = Get-wmiobject Win32_PhysicalMemory | Select Speed
[String]$empfanggrakaname = Get-WmiObject -class win32_VideoController | Select Description
[String]$empfanggpuram = Get-WmiObject -class win32_VideoController | Select AdapterRAM
$nl = [System.Environment]::NewLine # Zeilenumbruch einer Variable zuweisen
"Erzeuge lesbare Daten"

#Namen bereinigen  
    $Tempname = $empfangsname.Remove(0,7)
    $Name = $Tempname.Replace("GHz}",$null)
    $Name = $Tempname.Replace("}",$null)

#Anzahlkerne bereinigen
    $Tempcore = $empfangscores.Remove(0,16)
    $Tempcore = $Tempcore.Replace("}",$null)
    [int]$Cores = $Tempcore

#Logischekerne bereinigen
    $Templcore = $empfangslcores.Remove(0,28)
    $Templcore = $Tempcore.Replace("}",$null)
    [int]$LCores = $Templcore

#Logischekerne bereinigen
    $Tempspeed = $empfangsspeed.Remove(0,16)
    $Tempspeed = $Tempspeed.Replace("}",$null)
    [int]$Speed = $Tempspeed

#RAM bereinigen
    $Tempram = $empfangsram.Remove(0,22)
    $Tempram = $Tempram.Replace("}",$null)
    $Tempram = $Tempram / 1024 / 1024 / 1024
    [int]$RAM = $Tempram

#RAMtyp bereinigen
    $Tempramtyp = $empfangsramtyp.Remove(0,8)
    $Tempramtyp = $Tempramtyp.Replace("}",$null)
    [int]$RAMTYP
    switch ($Tempramtyp)
    {
    2133 {$RAMTYP = 4}
    1866 {$RAMTYP = 4}
    1600 {$RAMTYP = 4}
    1333 {$RAMTYP = 3}
    800 {$RAMTYP = 2}
    667 {$RAMTYP = 2}
    400 {$RAMTYP = 1}
    }
#Hersteller bereinigen
    $Temphersteller = $empfangshersteller.Remove(0,15)
    $Hersteller = $Temphersteller.Replace("}",$null)
#Seriennummer bereinigen
    $Tempseriennummer = $empfangsseriennummer.Remove(0,15)
    $Seriennummer = $Tempseriennummer.Replace("}",$null)
#Grakanamen bereinigen
    $Tempempfanggrakaname = $empfanggrakaname.Remove(0,14)
    $GPUName = $Tempempfanggrakaname.Replace("}",$null)
#GPURAM bereinigen
    $Tempgpuram = $empfanggpuram.Remove(0,13)
    $Tempgpuram = $Tempgpuram.Replace("}",$null)
    $Tempgpuram = $Tempgpuram / 1024 / 1024 / 1024
    [int]$GPURAM = $Tempgpuram
"Fertig..."

"$Name - $Cores Kerne - $LCores Threads - $Speed Mhz - $RAM GB DDR$RAMTYP RAM"
"PC(BIOS)-Hersteller:$Hersteller"
"PC-Seriennummer:$Seriennummer"
"Grafikkarte:$GPUName mit $GPURAM GB VRAM"
$hdds = Get-PhysicalDisk | Select Model , UniqueId , SerialNumber , Size , BusType, HealthStatus , OperationalStatus

$a = "$Name - $Cores Kerne - $LCores Threads - $Speed Mhz - $RAM GB RAM" +$nl+ "PC(BIOS)-Hersteller:$Hersteller" + $nl + "PC-Seriennummer:$Seriennummer" + $nl + "Grafikkarte:$GPUName mit $GPURAM GB VRAM" + $nl + $hdds
out-file -filepath Auslesen.txt -inputobject $a -encoding ASCII -width 50