"Hole RAW Daten"
[String]$empfangsname = Get-WmiObject -class win32_processor -Property  "Name" | Select-Object -Property "Name"
[String]$empfangscores = Get-WmiObject -class win32_processor -Property  "numberOfCores" | Select-Object -Property "numberOfCores"
[String]$empfangslcores = Get-WmiObject -class win32_processor -Property  "NumberOfLogicalProcessors" | Select-Object -Property "NumberOfLogicalProcessors"
[String]$empfangsspeed = Get-WmiObject -class win32_processor -Property  "maxclockspeed" | Select-Object -Property "maxclockspeed"
[String]$empfangshersteller = Get-WmiObject -class Win32_BIOS | Select Manufacturer
[String]$empfangsseriennummer = Get-WmiObject -class Win32_BIOS | Select SerialNumber
[String]$empfangsram = Get-wmiobject -class Win32_ComputerSystem | Select TotalPhysicalMemory
[String]$empfangsramtyp = Get-wmiobject Win32_PhysicalMemory | Select Speed -first 1
[String]$empfanggrakaname = Get-WmiObject -class win32_VideoController | Select Description | Where-Object {$_.Description -like "intel*" -or $_.Description -like "nvidia*" -or $_.Description -like "amd*"}
[String]$empfanggpuram = Get-WmiObject -class win32_VideoController | Select AdapterRAM
#[String]$empfangsmb = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol | Select State
$empfanginstalldatum = Get-WmiObject Win32_OperatingSystem

$hdds = Get-PhysicalDisk | Select Model , SerialNumber , Size , BusType, HealthStatus , OperationalStatus

$nl = [System.Environment]::NewLine # Zeilenumbruch einer Variable zuweisen
$username = [System.Environment]::UserName
$Dateiname = "$env:computername.txt"
$Pfad ="C:\"
[int]$RAMTYP = 0
[int]$GPURAM = 0
[int]$Cores = 0
[int]$LCores = 0
[int]$Speed = 0
[int]$RAM = 0

"Erzeuge lesbare Daten..."

#Namen bereinigen  
    $Tempname = $empfangsname.Remove(0,7)
    $Name = $Tempname.Replace("GHz}",$null)
    $Name = $Tempname.Replace("}",$null)

#Anzahlkerne bereinigen
    $Tempcore = $empfangscores.Remove(0,16)
    $Tempcore = $Tempcore.Replace("}",$null)
    $Cores = $Tempcore

#Logischekerne bereinigen
    $Templcore = $empfangslcores.Remove(0,28)
    $Templcore = $Templcore.Replace("}",$null)
    $LCores = $Templcore

#Logischekerne bereinigen
    $Tempspeed = $empfangsspeed.Remove(0,16)
    $Tempspeed = $Tempspeed.Replace("}",$null)
    $Speed = $Tempspeed

#RAM bereinigen
    $Tempram = $empfangsram.Remove(0,22)
    $Tempram = $Tempram.Replace("}",$null)
    $Tempram = $Tempram / 1024 / 1024 / 1024
    $RAM = $Tempram

#RAMtyp bereinigen
    $Tempramtyp = $empfangsramtyp.Remove(0,8)
    $Tempramtyp = $Tempramtyp.Replace("}",$null)
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
    if($empfanggpuram -isnot "empty")
    {
    $Tempgpuram = $empfanggpuram.Remove(0,13)
    $Tempgpuram = $Tempgpuram.Replace("}",$null)
    $Tempgpuram = $Tempgpuram / 1024 / 1024 / 1024
    $GPURAM = $Tempgpuram
    }
    else
    {
     $GPURAM = 0
    }
    #SMB bereinigen
    $Tempsmb = $empfangsmb.Remove(0,8)
    $smb = $Tempsmb.Replace("}",$null)
#Installations-Datum bereinigen
    $idatum = $empfanginstalldatum.ConvertToDateTime($empfanginstalldatum.InstallDate)
	

Write-Host * Fertig mit auslesen... * -ForegroundColor green -BackgroundColor black	
Write-Host * Daten werden geschrieben... * -ForegroundColor green -BackgroundColor black	

$a = $env:computername + $nl + "$Name - $Cores Kerne - $LCores Threads - $Speed Mhz - $RAM GB RAM" +$nl+ "PC(BIOS)-Hersteller: $Hersteller" + $nl + "PC-Seriennummer: $Seriennummer" + $nl + "Grafikkarte: $GPUName mit $GPURAM GB VRAM" + $nl + "Festplattendaten:" + $nl + $hdds + $nl + "Windows wurde am: " + $idatum + " installiert" + $nl + "aktiver Benutzer: $username" + $nl + $nl
out-file -filepath $Dateiname -inputobject $a -encoding ASCII -width 50

Add-Content liste.txt $a
"Daten aufgeschrieben: $Dateiname"
