start-transcript -append -OutputDirectory "C:\Users\peters\OneDrive - Organization\Documents\PowerShell Logs\"
set-location c:\
Set-Alias pcx C:\sysTools\procexp.exe
set-alias npp 'C:\Program Files (x86)\Notepad++\notepad++.exe'
set-alias ssh plink
set-alias sid resolve-sid
set-alias pop pop-location
set-alias push push-location
set-alias gs get-syntax
set-alias which get-command

#dotsource downloaded scripts to import them.
Get-ChildItem -Path "C:\Users\peters\OneDrive - organization\PSDL" | ForEach-Object {. $($_.FullName)}

add-type -AssemblyName System.speech

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

$FormatEnumerationLimit = -1

<# RETURN ALL IP ADDRESSES #> 
$localipaddress = @(Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled=$true").IPAddress
$pubaddr = Resolve-DnsName -Server resolver1.opendns.com -name myip.opendns.com
$amiadmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -like "S-1-5-32-544") 
$privatecert = (dir cert:currentuser\my\ -codesigningcert)

function prof { npp $profile }
function Prompt {
	$env:COMPUTERNAME + "\" + (Get-Location) + "\PS#> "
}
## ForceMKDIR
function force-mkdir($path) {
    if (!(Test-Path $path)) {
        Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
}
<#AUDIBLE PING
##
#>
function ping-speak ([string] $target) {
	$speak = new-object System.speech.Synthesis.SpeechSynthesizer
	While ($true) {if (test-connection $target -count 1 -quiet)
	{$speak.Speak($target + " is up!")}
	else
	{$speak.Speak( "Please wait, " + $target + "is down!");
	sleep 5
	}	
	}
}
##Beep-ping
function ping-beep ([string] $beeper)
{
	while((Test-Connection $beeper -quiet)){};
	[console]::beep(500,300)
}

function prep-powercli () {
	Get-Module -Name VMware* -ListAvailable | Import-Module
}


#Spin-wheeloflunch
Function petes-WheelOfLunch {
    $FastFood = @(
                    "Burger King",
                    "McDonald's",
                    "KFC",
                    "ole cafe",
                    "Obs Cafe",
                    "Sunshine Take-Aways & Mini Market",
                    "Fionas Takeaway",
                    "Obz Fisheries and Take Out",
                    "Narona",
                    "Spar",
                    "Steers",
                    "Altomar Fish And Chips",
                    "Just drink some water dude."
                    )
    $Mexican = @(
                    "Fat Cactus",
                    "Panchos",
                    "Luis Mexican Food & Grill"
                    )
    $Authentic = @(
                    "Blue Marlin Asian Cuisine and Sushi Bar",
                    "1890 House Sushi and Grill",
					"Simply Asia",
					"Wok in a Box",
                    "Hibachi Buffet"
                    )
    $Indian = @(
                    "Metropolis Grill",
                    "Curry Mantra"
                    )
    $Italian = @(
                    "Olive Garden",
                    "Marco's Pizza",
                    "Mellow Mushroom",
                    "Atlanta Bread Company",
                    "Marco Ristorante",
                    "Mama Mia"
                    )
    $Pizza = @(
                    "Pizza Hut",
                    "Domino's Pizza",
					"Portalia",
					"Mica Schawarma and Pizza",
					"Pizza Co",
					"YARD DOGS BOLLOCKS AND PIZZA WAREHOUSE",
					"Col Cacchio",
					"love is pizza",
					"salt and sugar rondebosch",
					"Bin rashied rondebosch",
					"narona",
					"frozen meh"
                    )
    $Burgers = @(
                    "Burger King",
                    "McDonalds",
                    "Budddy's Burgers",
                    "Checkers",
                    "Jerry's Burger Bar",
                    "Anvil Burger Co",
                    "StickyBBQ"
                    "Redemption Real Burgers",
                    "Red Robin",
					"Steers",
					"Devils Peak",
					"Hog & Rose",
					"Burgerboss",
					"Rocomamas",
					"Barcelos",
					"Pedros",
					"Obs Cafe",
					"BURGRRR Woodstock",
					"The Mash Tun"
                    )
    $Buffet = @(
                    "Grill & Barrel",
					"Food Inn"		
                    )
    $Vietnamese = @(
                    "Monsoon Thai & Vietnamese",
                    "Thai Pepper"
                    )
    $BBQ = @(
                    "Sticky Fingers BBQ",
                    "Sonny's BBQ"
                    )
    $Frozen = @(
                    "mcdonalds shake?",
                    "marcels",
                    "milky lane"
                    )
    $All = @(
                $FastFood,
                $Mexican,
                $Authentic,
                $Pizza,
                $Burgers,
                $Frozen,
                $Vietnamese,
                $BBQ,
                $Buffet,
                $Greek,
                $Italian,
                $Indian
                )
    $Captions = @(
                "Fast Food",
                "Mexican",
                "Authentic",
                "Pizza",
                "Burgers",
                "Frozen",
                "Vietnamese",
                "BBQ",
                "Buffet",
                "Greek",
                "Italian",
                "Indian"
                )

    # The magic happens...

    $SelectionNum = Get-Random -Minimum 0 -Maximum $($All.Length-1)
    "Type: "+$Captions[$SelectionNum]
    "Restaurant: "+$All[$SelectionNum][$(Get-Random -Minimum 0 -Maximum $($All[$SelectionNum].Length-1))]
    }

#SYNTAX FUNCTION
function get-syntax([string] $cmdlet) {
   get-command $cmdlet -syntax
}

#GET IPs Function 
function get-ips {write-host $localipaddress}

##Function-resolve sid
function Resolve-SID($stringSid) {
  $objSID = New-Object System.Security.Principal.SecurityIdentifier($stringSid) 
  $objUser = $objSID.Translate([System.Security.Principal.NTAccount]) 
  $objUser.Value
}

##MOTD
Function Get-MOTD {
<#
.NAME
    Get-MOTD
.SYNOPSIS
    Displays system information to a host.
.DESCRIPTION
    The Get-MOTD cmdlet is a system information tool written in PowerShell. 
.EXAMPLE
#>

  [CmdletBinding()]
	
  Param(
    [Parameter(Position=0,Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
    [string[]]$ComputerName
    ,
    [Parameter(Position=1,Mandatory=$false)]
    [PSCredential]
    [System.Management.Automation.CredentialAttribute()]$Credential
  )

  Begin {
	
      If (-Not $ComputerName) {
          $RemoteSession = $null
        }
        #Define ScriptBlock for data collection
        $ScriptBlock = {
            $Operating_System = Get-CimInstance -ClassName Win32_OperatingSystem
            $Logical_Disk = Get-CimInstance -ClassName Win32_LogicalDisk |
            Where-Object -Property DeviceID -eq $Operating_System.SystemDrive
			Try {
				$PCLi = get-module vmware*
				#$PCLi = Get-PowerCLIVersion
				$PCLiVer = ' | PowerCLi ' + [string]$PCLi.Major + '.' + [string]$PCLi.Minor + '.' + [string]$PCLi.Revision + '.' + [string]$PCLi.Build
			} Catch {$PCLiVer = ''}
			If ($DomainName = ([System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()).DomainName) {$DomainName = '.' + $DomainName}
			
           [pscustomobject]@{
               Operating_System = $Operating_System
                Processor = Get-CimInstance -ClassName Win32_Processor
                Process_Count = (Get-Process).Count
                Shell_Info = ("{0}.{1}" -f $PSVersionTable.PSVersion.Major,$PSVersionTable.PSVersion.Minor) + $PCLiVer
                Logical_Disk = $Logical_Disk
            }
        }
} #End Begin

  Process {
	
        If ($ComputerName) {
            If ("$ComputerName" -ne "$env:ComputerName") {
                # Build Hash to be used for passing parameters to 
                # New-PSSession commandlet
                $PSSessionParams = @{
                    ComputerName = $ComputerName
                    ErrorAction = 'Stop'
                }

                # Add optional parameters to hash
                If ($Credential) {
                    $PSSessionParams.Add('Credential', $Credential)
                }

                # Create remote powershell session   
                Try {
                    $RemoteSession = New-PSSession @PSSessionParams
                }
                Catch {
                    Throw $_.Exception.Message
                }
            } Else { 
                $RemoteSession = $null
            }
        }
        
        # Build Hash to be used for passing parameters to 
        # Invoke-Command commandlet
        $CommandParams = @{
            ScriptBlock = $ScriptBlock
            ErrorAction = 'Stop'
        }
        
        # Add optional parameters to hash
        If ($RemoteSession) {
            $CommandParams.Add('Session', $RemoteSession)
        }
               
        # Run ScriptBlock    
        Try {
            $ReturnedValues = Invoke-Command @CommandParams
        }
        Catch {
            If ($RemoteSession) {
            	Remove-PSSession $RemoteSession
            }
            Throw $_.Exception.Message
        }

        # Assign variables
        $Date = Get-Date
        $OS_Name = $ReturnedValues.Operating_System.Caption + ' [Installed: ' + ([datetime]$ReturnedValues.Operating_System.InstallDate).ToString('dd-MMM-yyyy') + ']'
        $Computer_Name = $ReturnedValues.Operating_System.CSName
		If ($DomainName) {$Computer_Name = $Computer_Name + $DomainName.ToUpper()}
        $Kernel_Info = $ReturnedValues.Operating_System.Version + ' [' + $ReturnedValues.Operating_System.OSArchitecture + ']'
        $Process_Count = $ReturnedValues.Process_Count
        $Uptime = "$(($Uptime = $Date - $($ReturnedValues.Operating_System.LastBootUpTime)).Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes"
        $Shell_Info = $ReturnedValues.Shell_Info
        $CPU_Info = $ReturnedValues.Processor.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' '
        $Current_Load = $ReturnedValues.Processor.LoadPercentage    
        $Memory_Size = "{0} MB/{1} MB " -f (([math]::round($ReturnedValues.Operating_System.TotalVisibleMemorySize/1KB))-
        ([math]::round($ReturnedValues.Operating_System.FreePhysicalMemory/1KB))),([math]::round($ReturnedValues.Operating_System.TotalVisibleMemorySize/1KB))
		$Disk_Size = "{0} GB/{1} GB" -f (([math]::round($ReturnedValues.Logical_Disk.Size/1GB)-
        [math]::round($ReturnedValues.Logical_Disk.FreeSpace/1GB))),([math]::round($ReturnedValues.Logical_Disk.Size/1GB))

        # Write to the Console
        Write-Host -Object ("")
        Write-Host -Object ("")
        Write-Host -Object ("         ,.=:^!^!t3Z3z.,                  ") -ForegroundColor Red
        Write-Host -Object ("        :tt:::tt333EE3                    ") -ForegroundColor Red
        Write-Host -Object ("        Et:::ztt33EEE ") -NoNewline -ForegroundColor Red
        Write-Host -Object (" @Ee.,      ..,     $($Date.ToString('dd-MMM-yyyy HH:mm:ss'))") -ForegroundColor Green
        Write-Host -Object ("       ;tt:::tt333EE7") -NoNewline -ForegroundColor Red
        Write-Host -Object (" ;EEEEEEttttt33#     ") -ForegroundColor Green
        Write-Host -Object ("      :Et:::zt333EEQ.") -NoNewline -ForegroundColor Red
        Write-Host -Object (" SEEEEEttttt33QL     ") -NoNewline -ForegroundColor Green
        Write-Host -Object ("User: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$env:USERDOMAIN\$env:UserName") -ForegroundColor Cyan
        Write-Host -Object ("      it::::tt333EEF") -NoNewline -ForegroundColor Red
        Write-Host -Object (" @EEEEEEttttt33F      ") -NoNewline -ForeGroundColor Green
        Write-Host -Object ("Hostname: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Computer_Name") -ForegroundColor Cyan
        Write-Host -Object ("     ;3=*^``````'*4EEV") -NoNewline -ForegroundColor Red
        Write-Host -Object (" :EEEEEEttttt33@.      ") -NoNewline -ForegroundColor Green
        Write-Host -Object ("OS: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$OS_Name") -ForegroundColor Cyan
        Write-Host -Object ("     ,.=::::it=., ") -NoNewline -ForegroundColor Cyan
        Write-Host -Object ("``") -NoNewline -ForegroundColor Red
        Write-Host -Object (" @EEEEEEtttz33QF       ") -NoNewline -ForegroundColor Green
        Write-Host -Object ("Kernel: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("NT ") -NoNewline -ForegroundColor Cyan
        Write-Host -Object ("$Kernel_Info") -ForegroundColor Cyan
        Write-Host -Object ("    ;::::::::zt33) ") -NoNewline -ForegroundColor Cyan
        Write-Host -Object ("  '4EEEtttji3P*        ") -NoNewline -ForegroundColor Green
        Write-Host -Object ("Uptime: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Uptime") -ForegroundColor Cyan
        Write-Host -Object ("   :t::::::::tt33.") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (":Z3z.. ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object (" ````") -NoNewline -ForegroundColor Green
        Write-Host -Object (" ,..g.        ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("Shell: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("PowerShell $Shell_Info") -ForegroundColor Cyan
        Write-Host -Object ("   i::::::::zt33F") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (" AEEEtttt::::ztF         ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("CPU: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$CPU_Info") -ForegroundColor Cyan
        Write-Host -Object ("  ;:::::::::t33V") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (" ;EEEttttt::::t3          ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("Processes: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Process_Count") -ForegroundColor Cyan
        Write-Host -Object ("  E::::::::zt33L") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (" @EEEtttt::::z3F          ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("Current Load: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Current_Load") -NoNewline -ForegroundColor Cyan
        Write-Host -Object ("%") -ForegroundColor Cyan
        Write-Host -Object (" {3=*^``````'*4E3)") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (" ;EEEtttt:::::tZ``          ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("Memory: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Memory_Size`t") -ForegroundColor Cyan -NoNewline
		New-PercentageBar -DrawBar -Value (([math]::round($ReturnedValues.Operating_System.TotalVisibleMemorySize/1KB))-([math]::round($ReturnedValues.Operating_System.FreePhysicalMemory/1KB))) -MaxValue ([math]::round($ReturnedValues.Operating_System.TotalVisibleMemorySize/1KB)); "`r"
        Write-Host -Object ("             ``") -NoNewline -ForegroundColor Cyan
        Write-Host -Object (" :EEEEtttt::::z7            ") -NoNewline -ForegroundColor Yellow
        Write-Host -Object ("System Volume: ") -NoNewline -ForegroundColor Red
        Write-Host -Object ("$Disk_Size`t") -ForegroundColor Cyan -NoNewline
		New-PercentageBar -DrawBar -Value (([math]::round($ReturnedValues.Logical_Disk.Size/1GB)-[math]::round($ReturnedValues.Logical_Disk.FreeSpace/1GB))) -MaxValue ([math]::round($ReturnedValues.Logical_Disk.Size/1GB)); "`r"
        Write-Host -Object ("                 'VEzjt:;;z>*``            ") -ForegroundColor Yellow -NoNewLine
		Write-Host -Object ("Am I Admin? ") -ForegroundColor Red -NoNewLine
		Write-Host -Object ($amiadmin) -ForegroundColor Cyan
        Write-Host -Object ("                      ````                  ") -ForegroundColor Yellow -NoNewLine
        Write-Host -Object ("Local IPs: ") -ForegroundColor Red -NoNewLine
		write-host $localipaddress -ForegroundColor Cyan -NoNewline
		Write-Host -Object (" Public IP: ") -ForegroundColor Red -NoNewLine
		Write-Host -Object ($pubaddr.ipaddress) -ForegroundColor Cyan	
  } #End Process

  End {
        If ($RemoteSession) {
            Remove-PSSession $RemoteSession
        }
  }
} #End Function Get-MOTD

cls
get-motd
get-alias |Get-Random -Count 10 | ft @{label='aliases'; expression={$_.displayname}},helpuri

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
