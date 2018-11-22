
#usage install-software-windows.ps1 dnsname

param
(
      [string]$dnsName = $null,
	  [string]$adminUser
)


#Create C:\var\log folder
$sourcevar = 'C:\var' 
If (!(Test-Path -Path $sourcevar -PathType Container)) 
{New-Item -Path $sourcevar -ItemType Directory | Out-Null}
Else
{ Exit }
$sourcelog = 'C:\var\log' 
If (!(Test-Path -Path $sourcelog -PathType Container)) {New-Item -Path $sourcelog -ItemType Directory | Out-Null} 
#Create C:\git folder
$sourcegit = 'C:\git' 
If (!(Test-Path -Path $sourcegit -PathType Container)) {New-Item -Path $sourcegit -ItemType Directory | Out-Null} 
$sourcebash = 'C:\git\bash' 
If (!(Test-Path -Path $sourcebash -PathType Container)) {New-Item -Path $sourcebash -ItemType Directory | Out-Null} 
 

function WriteLog($msg)
{
Write-Host $msg
$msg >> c:\var\log\install.log
}
function WriteDateLog
{
date >> c:\var\log\install.log
}
if(!$dnsName) {
 WriteLog "DNSName not specified" 
 throw "DNSName not specified"
}
function DownloadAndUnzip($sourceUrl,$DestinationDir ) 
{
    $TempPath = [System.IO.Path]::GetTempFileName()
    if (($sourceUrl -as [System.URI]).AbsoluteURI -ne $null)
    {
        $handler = New-Object System.Net.Http.HttpClientHandler
        $client = New-Object System.Net.Http.HttpClient($handler)
        $client.Timeout = New-Object System.TimeSpan(0, 30, 0)
        $cancelTokenSource = [System.Threading.CancellationTokenSource]::new()
        $responseMsg = $client.GetAsync([System.Uri]::new($sourceUrl), $cancelTokenSource.Token)
        $responseMsg.Wait()
        if (!$responseMsg.IsCanceled)
        {
            $response = $responseMsg.Result
            if ($response.IsSuccessStatusCode)
            {
                $downloadedFileStream = [System.IO.FileStream]::new($TempPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
                $copyStreamOp = $response.Content.CopyToAsync($downloadedFileStream)
                $copyStreamOp.Wait()
                $downloadedFileStream.Close()
                if ($copyStreamOp.Exception -ne $null)
                {
                    throw $copyStreamOp.Exception
                }
            }
        }
    }
    else
    {
        throw "Cannot copy from $sourceUrl"
    }
    [System.IO.Compression.ZipFile]::ExtractToDirectory($TempPath, $DestinationDir)
    Remove-Item $TempPath
}
function Download($sourceUrl,$DestinationDir ) 
{
    if (($sourceUrl -as [System.URI]).AbsoluteURI -ne $null)
    {
        $handler = New-Object System.Net.Http.HttpClientHandler
        $client = New-Object System.Net.Http.HttpClient($handler)
        $client.Timeout = New-Object System.TimeSpan(0, 30, 0)
        $cancelTokenSource = [System.Threading.CancellationTokenSource]::new()
        $responseMsg = $client.GetAsync([System.Uri]::new($sourceUrl), $cancelTokenSource.Token)
        $responseMsg.Wait()
        if (!$responseMsg.IsCanceled)
        {
            $response = $responseMsg.Result
            if ($response.IsSuccessStatusCode)
            {
                $downloadedFileStream = [System.IO.FileStream]::new($DestinationDir, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
                $copyStreamOp = $response.Content.CopyToAsync($downloadedFileStream)
                $copyStreamOp.Wait()
                $downloadedFileStream.Close()
                if ($copyStreamOp.Exception -ne $null)
                {
                    throw $copyStreamOp.Exception
                }
            }
        }
    }
    else
    {
        throw "Cannot copy from $sourceUrl"
    }
}

function Expand-ZIPFile($file, $destination) 
{ 
    $shell = new-object -com shell.application 
    $zip = $shell.NameSpace($file) 
    foreach($item in $zip.items()) 
    { 
        # Unzip the file with 0x14 (overwrite silently) 
        $shell.Namespace($destination).copyhere($item, 0x14) 
    } 
} 
WriteDateLog

WriteLog "Downloading git" 
$url = 'https://github.com/git-for-windows/git/releases/download/v2.14.2.windows.1/Git-2.14.2-64-bit.exe' 
$EditionId = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'EditionID').EditionId
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	Download $url $sourcebash 
	WriteLog "git downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcebash + "\Git-2.14.2-64-bit.exe" )  
	WriteLog "git downloaded"  
}
WriteLog "Downloading visual studio" 
$url = 'https://aka.ms/vs/15/release/vs_community.exe' 
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	Download $url $sourcebash 
	WriteLog "visual studio downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcebash + "\vs_community.exe" )  
	WriteLog "visual studio downloaded"  
}
WriteLog "Downloading bzip2" 
$url = 'https://github.com/philr/bzip2-windows/releases/download/v1.0.6/bzip2-1.0.6-win-x64.zip'
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	DownloadAndUnzip $url $sourcebash 
	WriteLog "bzip2 downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcebash + "\bzip2-1.0.6-win-x64.zip" )  
	# Function to unzip file contents 
	Expand-ZIPFile -file "$sourcebash\bzip2-1.0.6-win-x64.zip" -destination $sourcebash 
	WriteLog "bzip2 downloaded"  
}

WriteLog "Downloading msvcr120.dll" 
$url = 'https://raw.githubusercontent.com/flecoqui/azure/master/azure-quickstart-templates/101-vm-simple-universal-dlib/msvcr120.dll' 
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	Download $url $sourcebash 
	WriteLog "msvcr120.dll downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcebash + "\msvcr120.dll" )  
	WriteLog "msvcr120.dll downloaded"  
}

WriteLog "Downloading cmake" 
$url = 'https://cmake.org/files/v3.9/cmake-3.9.3-win64-x64.zip'
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	DownloadAndUnzip $url $sourcebash 
	WriteLog "cmake downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcebash + "\cmake-3.9.3-win64-x64.zip" )  
	# Function to unzip file contents 
	Expand-ZIPFile -file "$sourcebash\cmake-3.9.3-win64-x64.zip" -destination $sourcebash 
	WriteLog "cmake downloaded"  
}
WriteLog "Downloading boost source code" 
$url = 'https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.zip'
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	Download $url $sourcegit 
	WriteLog "boost downloaded" 
}
else
{
	$webClient = New-Object System.Net.WebClient  
	$webClient.DownloadFile($url,$sourcegit + "\boost_1_65_1.zip" )  
	WriteLog "boost downloaded"  
}
function Install-IIS
{
WriteLog "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
WriteLog "Save-Module -Path "$env:programfiles\WindowsPowerShell\Modules\" -Name NanoServerPackage -minimumVersion 1.0.1.0"
Save-Module -Path "$env:programfiles\WindowsPowerShell\Modules\" -Name NanoServerPackage -minimumVersion 1.0.1.0
WriteLog "Import-PackageProvider NanoServerPackage"
Import-PackageProvider NanoServerPackage
WriteLog "Find-NanoServerPackage -name *"
Find-NanoServerPackage -name *
WriteLog "Find-NanoServerPackage *iis* | install-NanoServerPackage -culture en-us"
Find-NanoServerPackage *iis* | install-NanoServerPackage -culture en-us
}
WriteLog "Installing IIS"  
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
Install-IIS
}
else
{
Install-WindowsFeature -Name "Web-Server"
}
WriteLog "Installing IIS: done"


WriteLog "Configuring firewall" 
function Add-FirewallRulesNano
{
New-NetFirewallRule -Name "HTTP" -DisplayName "HTTP" -Protocol TCP -LocalPort 80 -Action Allow -Enabled True
New-NetFirewallRule -Name "HTTPS" -DisplayName "HTTPS" -Protocol TCP -LocalPort 443 -Action Allow -Enabled True
New-NetFirewallRule -Name "WINRM1" -DisplayName "WINRM TCP/5985" -Protocol TCP -LocalPort 5985 -Action Allow -Enabled True
New-NetFirewallRule -Name "WINRM2" -DisplayName "WINRM TCP/5986" -Protocol TCP -LocalPort 5986 -Action Allow -Enabled True
}
function Add-FirewallRules
{
New-NetFirewallRule -Name "HTTP" -DisplayName "HTTP" -Protocol TCP -LocalPort 80 -Action Allow -Enabled True
New-NetFirewallRule -Name "HTTPS" -DisplayName "HTTPS" -Protocol TCP -LocalPort 443 -Action Allow -Enabled True
New-NetFirewallRule -Name "RDP" -DisplayName "RDP TCP/3389" -Protocol TCP -LocalPort 3389 -Action Allow -Enabled True
}
if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
	Add-FirewallRulesNano
}
else
{
	Add-FirewallRules
}
WriteLog "Firewall configured" 


WriteLog "Creating Home Page" 
$ExternalIP = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

if (($EditionId -eq "ServerStandardNano") -or
    ($EditionId -eq "ServerDataCenterNano") -or
    ($EditionId -eq "NanoServer") -or
    ($EditionId -eq "ServerTuva")) {
$LocalIP = Get-NetIPAddress -InterfaceAlias 'Ethernet' -AddressFamily IPv4
$BuildNumber = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'CurrentBuild').CurrentBuild
$osstring = @'
OS {1} BuildNumber {2}
'@
$osstring = $osstring -replace "\{1\}",$EditionId
$osstring = $osstring -replace "\{2\}",$BuildNumber
}
else
{
$LocalIP = Get-NetIPAddress -InterfaceAlias 'Ethernet 3' -AddressFamily IPv4
$OSInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory, NumberOfUsers, BootDevice
$osstring = @'
OS {1} Version {2} Architecture {3}
'@
$osstring = $osstring -replace "\{1\}",$OSInfo.Caption
$osstring = $osstring -replace "\{2\}",$OSInfo.Version
$osstring = $osstring -replace "\{3\}",$OSInfo.OSArchitecture
}
If (!(Test-Path -Path C:\inetpub -PathType Container)) {New-Item -Path C:\inetpub -ItemType Directory | Out-Null} 
If (!(Test-Path -Path C:\inetpub\wwwroot -PathType Container)) {New-Item -Path C:\inetpub\wwwroot -ItemType Directory | Out-Null} 
$content = @'
<html>
  <head>
    <title>Sample "Hello from {0}" </title>
  </head>
  <body bgcolor=white>
    <table border="0" cellpadding="10">
      <tr>
        <td>
          <h1>Hello from {0}</h1>
		  <p>{1}</p>
		  <p>Local IP Address: {2} </p>
		  <p>External IP Address: {3} </p>
        </td>
      </tr>
    </table>

    <p>This is the home page for the DLIB test on Azure VM</p>
    <p>Launch the following command line from your client to open an RDP session: </p>
    <p>     mstsc /admin /v:{0}  </p>
	<p>Launch the following commands in the RDP session from C:\GIT\BASH : </p>
    <p>     buildDLIB.bat: to build DLIB library with VC++ 2017</p> 
    <p>     buildDLIBCPPSamples.bat: to build DLIB C++ samples with VC++ 2017 (won't work: will fail when compiling dnn_face_recognition_ex.cpp )</p> 
	<p>     buildBoostForPython.bat: to build BOOST library with VC++ 2017 (not necessary for the tests)</p>
    <p>     bash buildDLIBPythonSamples.bat: to build DLIB Python samples with VC++ 2017 (won't work: VC++ bug while compiling dnn component) </p> 
    <p>          As it's not possible to generate the python library, by default the DLIB library is imported with Anaconda3 x64 </p> 
    <p>     bash runDLIBTests.bat: to run DLIB tests </p> 
	<p>To test DLIB, change directory under /git/dlib/python_examples and run the following command:</p>
	<p>      ./face_landmark_detection.py ../../dlib-models/shape_predictor_68_face_landmarks.dat ../examples/faces</p>
    <ul>
      <li>To <a href="http://www.microsoft.com">Microsoft</a>
      <li>To <a href="https://portal.azure.com">Azure</a>
    </ul>
  </body>
</html>
'@
$content = $content -replace "\{0\}",$dnsName
$content = $content -replace "\{1\}",$osstring
$content = $content -replace "\{2\}",$LocalIP.IPAddress
$content = $content -replace "\{3\}",$ExternalIP

$content | Out-File -FilePath C:\inetpub\wwwroot\index.html -Encoding utf8
WriteLog "Creating Home Page done" 

WriteLog "Starting IIS" 
net start w3svc

WriteLog "Installing git" 
Start-Process -FilePath "c:\git\bash\Git-2.14.2-64-bit.exe" -Wait -ArgumentList "/VERYSILENT","/SUPPRESSMSGBOXES","/NORESTART","/NOCANCEL","/SP-","/LOG"

$count=0
while ((!(Test-Path "C:\Program Files\Git\bin\git.exe"))-and($count -lt 20)) { Start-Sleep 10; $count++}
WriteLog "git Installed" 

WriteLog "Installing VS" 
Start-Process -FilePath "c:\git\bash\vs_community.exe" -Wait -ArgumentList "--quiet","--norestart","--wait","--add","Microsoft.VisualStudio.Workload.NativeCrossPlat","--add","Microsoft.VisualStudio.Workload.NativeDesktop","--add","Microsoft.VisualStudio.Workload.Python","--add","Component.Anaconda3.x64","--includeRecommended"
Start-Process -FilePath "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  -Wait -ArgumentList "x64"
WriteLog "VS Installed" 

WriteLog "Downloading DLIB source code"
cd c:\git
Start-Process -FilePath "C:\Program Files\Git\bin\git.exe" -Wait -ArgumentList "clone","https://github.com/davisking/dlib.git"
Start-Process -FilePath "C:\Program Files\Git\bin\git.exe" -Wait -ArgumentList "clone","https://github.com/davisking/dlib-models.git"
#uncompress models
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/dlib_face_recognition_resnet_model_v1.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/mmod_dog_hipsterizer.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/mmod_front_and_rear_end_vehicle_detector.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/mmod_human_face_detector.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/mmod_rear_end_vehicle_detector.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/resnet34_1000_imagenet_classifier.dnn.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/shape_predictor_5_face_landmarks.dat.bz2"
Start-Process -FilePath "c:\git\bash\bzip2.exe" -Wait -ArgumentList "-d","/git/dlib-models/shape_predictor_68_face_landmarks.dat.bz2"
WriteLog "DLIB source code downloaded" 


WriteLog "Setting Path for Python3 and cmake"
$LocalPath = [Environment]::GetEnvironmentVariable("Path","Machine")
[Environment]::SetEnvironmentVariable("Path", $LocalPath + ";C:\Program Files\Anaconda3;C:\Program Files\Anaconda3\Scripts;c:\git\bash\cmake-3.9.3-win64-x64\bin" , "Machine")
WriteLog "Setting done"

WriteLog "Installing DLIB for python Anaconda3"
Start-Process -FilePath "c:\Program Files\Anaconda3\Scripts\conda.exe" -Wait -ArgumentList   "install","-y","-c","conda-forge","dlib=19.4"
WriteLog "DLIB for python Anaconda3 installed"

WriteLog "Installing scikit-image"
Start-Process -FilePath "C:\Program Files\Anaconda3\Scripts\pip.exe" -Wait -ArgumentList   "scikit-image"
WriteLog "scikit-image installed"

WriteLog "Extracting boost source code"
Add-Type -A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::ExtractToDirectory('C:\git\boost_1_65_1.zip', 'C:\git')
WriteLog "boost source code unzipped"

WriteLog "Creating batch files"
New-Item c:\git\bash\buildDLIB.bat -type file -force -value @"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
cd c:\git\dlib 
mkdir build
cd build
cmake.exe .. 
cmake.exe --build . --config Release
"@


New-Item c:\git\bash\buildDLIBCPPSamples.bat -type file -force -value @"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
cd c:\git\dlib\examples
mkdir build
cd build
cmake.exe .. 
cmake.exe --build . 
"@


New-Item c:\git\bash\buildBoostForPython.bat -type file -force -value @"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
cd C:\git\boost_1_65_1\tools\build
bootstrap.bat
.\b2 --prefix=C:\boost-build-engine\bin install
cd C:\git\boost_1_65_1
C:\boost-build-engine\bin\bin\b2 -a --with-python address-model=64 toolset=msvc runtime-link=static
"@

New-Item c:\git\bash\buildDLIBPythonSamples.bat -type file -force -value @"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
set BOOST_ROOT=C:\git\boost_1_65_1
set BOOST_LIBRARYDIR=C:\git\boost_1_65_1\stage\lib
cd c:\git\dlib
python setup.py install
"@


New-Item c:\git\bash\runDLIBTests.bat -type file -force -value @"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"  x64
cd c:\git\dlib\dlib\test
mkdir build
cd build
cmake.exe .. 
cmake.exe --build . --config Release
"@




WriteLog "Initialization completed !" 
WriteLog "Rebooting !" 
Restart-Computer -Force       
