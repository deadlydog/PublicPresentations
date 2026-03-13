# Install the PowerShell extension.
# Intellisense and tab completion work in the console, scripts, and even here in the markdown file.
# Use Ctrl+Space to see all available completions at any point.

# See all available commands.
Get-Command

# See all available commands in a specific module.
Get-Command -Module Microsoft.PowerShell.Management

# Use Get-Help to learn about a specific command.
Get-Help Get-ChildItem

# Use Get-Help with the -Full parameter to see more details.
Get-Help Get-ChildItem -Full

# Use the -Online parameter to view the help content in a web browser.
Get-Help Get-ChildItem -Online

#----------

# Variables are expanded in double-quoted strings, but not single-quoted strings.
$string1 = "Hello, "
[string] $string2 = "World!"
$string1 + $string2
"$string1$string2"
'$string1$string2'

#----------

# Write-Output is implied when you write an expression or variable.
$number1 = 1
[int] $number2 = 2
$number1 + $number2
Write-Output ($number1 + $number2)

#----------

# PowerShell is not case-sensitive.
$number = 42
$NUMBER
$nUmBeR

#----------

# Assigning a typed variable with the wrong type results in an error.
[int] $number = "Hello"
$number

#----------

# Use Strict Mode to enforce variable declaration and other rules.
$undeclaredVariable
$null -eq $undeclaredVariable

Set-StrictMode -Version Latest
$undeclaredVariable

Set-StrictMode -Off

#----------

# See what properties and methods are available on an object, and it's type, using Get-Member.
Get-Process | Get-Member

# See all properties of an object using Select-Object.
Get-Process | Select-Object -First 1
Get-Process | Select-Object -First 1 -Property *

#----------

# Iterate over a collection of objects using ForEach-Object.
1..10 | ForEach-Object { Write-Output "Number: $PSItem" }

# % is an alias for ForEach-Object, and $_ is an alias for $PSItem.
1..10 | % { $_ }

# Can also use a foreach loop when you don't need the pipeline / streaming.
[int[]] $numbers = 1..10
foreach ($number in $numbers) {
	$number
}

#----------

# Can access variables outside the loop scope.
[int] $sum = 0
1..10 | ForEach-Object { $sum += $_ }
"Sum: $sum"

#----------

# Filter using Where-Object.
Get-Process |
	Where-Object { $_.WorkingSet -gt 500MB }

#----------

# Sort using Sort-Object.
Get-Process |
	? { $_.WorkingSet -gt 500MB } |
	Sort-Object -Property WorkingSet -Descending |
	Select-Object -Property Name, WorkingSet

# This is equivalent to the above, but using aliases and positional parameters.
Get-Process |
	Where { $_.WorkingSet -gt 500MB } |
	Sort WorkingSet -Descending |
	Select Name, WorkingSet

#----------

# See all aliases
Get-Alias
Get-Alias -Name ls
Get-Alias -Definition Get-ChildItem
Set-Alias -Name lucky -Value Get-Random
lucky

#----------

# Can add custom properties to any object using Add-Member.
$process = Get-Process | Select-Object -First 1
$process | Add-Member -MemberType NoteProperty -Name "DansProperty" -Value "DansValue"
$process.DansProperty
$process | Get-Member
$process | Select-Object Name, DansProperty

# Can also use calculated properties to add custom properties on the fly.
$process | Select-Object Name, @{Name="DansCalculatedProperty"; Expression={"DansCalculatedValue-" + $_.Name}} -First 1

$process | Select-Object Name, WorkingSet, @{Name = "MemoryInMb"; Expression = { $_.WorkingSet / 1MB } } -First 1

#----------

# Will error if you call a function that's not defined yet.
Write-HelloWorld

function Write-HelloWorld {
	Write-Output "Hello, World!"
}

Write-HelloWorld

#----------

# Functions can have parameters
function Write-Hello ($name, $age) {
	Write-Output "Hello, $name! You are $age years old."
}

Write-Hello "Alice" 25
Write-Hello 25 "Alice"
Write-Hello -name "Bob" -age 30

# Better to strongly type your parameters.
function Write-Hello ([string] $name, [int] $age) {
	Write-Output "Hello, $name! You are $age years old."
}

Write-Hello 25 "Alice"

#----------

# Functions can return multiple values.
function Get-NameAndAge1 {
	$name = "Charlie"
	$age = 30
	return $name, $age
}
Get-NameAndAge1

function Get-NameAndAge2 {
	"Charlie"
	30
}
Get-NameAndAge2

function Get-NameAndAge3 {
	"Charlie"
	return 30
}
Get-NameAndAge3

#----------

# Make sure you capture or discard output you do not want to return.
function Get-PingSucceeded1 {
	ping.exe google.com
	$? # $? is a special variable that contains the success status of the last command. It will be $true if the ping command succeeded, and $false if it failed.
}
Get-PingSucceeded1

function Get-PingSucceeded2 {
	ping.exe google.com | Out-Null
	$LASTEXITCODE -eq 0 # $LASTEXITCODE is a special variable that contains the exit code of the last native command. It will be 0 if the ping command succeeded, and non-zero if it failed.
}
Get-PingSucceeded2

function Get-PingSucceeded3 {
	$output = ping.exe google.com
	$output -like '*Received = 4*'
}
Get-PingSucceeded3

#----------

# Can call native .NET methods as well.
"Hello".ToUpper() | Out-File -FilePath 'C:\Temp\Hello.txt' -Encoding UTF8

[System.IO.File]::WriteAllText('C:\Temp\Hello2.txt', "Hello, World!", [System.Text.Encoding]::UTF8)

# Create paths and test if they exist.
$path = Join-Path -Path 'C:\Temp' -ChildPath 'Subfolder'
$path
Test-Path -Path $path
New-Item -Path $path -ItemType Directory
Test-Path -Path $path

$path2 = [System.IO.Path]::Combine('C:\Temp', 'Subfolder2')
$path2
[System.IO.Directory]::Exists($path2)
[System.IO.Directory]::CreateDirectory($path2)
[System.IO.Directory]::Exists($path2)

#----------

# Can get input from user using Read-Host.
$name = Read-Host "What is your name?"
Write-Output "Hello, $name!"

# Can use Out-GridView to display data and get user's choice.
# Out-GridView is Windows-only. Use Out-ConsoleGridView module for a cross-platform alternative.
$cars = @(
	[PSCustomObject]@{ Make = "Toyota"; Model = "Camry"; Year = "2020" }
	[PSCustomObject]@{ Make = "Honda"; Model = "Civic"; Year = "2019" }
	[PSCustomObject]@{ Make = "Ford"; Model = "Mustang"; Year = "2021" }
	[PSCustomObject]@{ Make = "Tesla"; Model = "Model 3"; Year = "2022" }
)
$cars | Out-GridView -Title "Select a car" -PassThru

# Can even display UI controls.
# Show message box popup and return the button clicked by the user.
function Read-MessageBoxDialog([string]$Message, [string]$WindowTitle, [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::None) {
	Add-Type -AssemblyName System.Windows.Forms
	return [System.Windows.Forms.MessageBox]::Show($Message, $WindowTitle, $Buttons, $Icon)
}

$buttonClicked = Read-MessageBoxDialog -Message "Please press the OK button." -WindowTitle "Message Box Example" -Buttons OKCancel -Icon Exclamation
if ($buttonClicked -eq "OK") { Write-Host "Thanks for pressing OK" }
else { Write-Host "You clicked $buttonClicked" }

#----------

# Many different streams for output.
Write-Output "Output stream."
Write-Error "Error stream."
Write-Warning "Warning stream."
Write-Information "Information stream (not shown by default)."
Write-Verbose "Verbose stream (not shown by default)."
Write-Debug "Debug stream (not shown by default)."

$InformationPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Break"

$ErrorActionPreference = "Stop" # Forces an exception to be thrown.
$ErrorActionPreference = "SilentlyContinue"

# Reset to default values.
$InformationPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"
$ErrorActionPreference = "Continue"

#----------

# Throw an exception to stop execution
"Hello"
throw "Throwing an exception halts execution!"
"World!"

# Use try/catch to handle exceptions.
try {
	Write-Output "Hello"
	Write-Error "ERROR: Execution will still continue after this error"
	throw "Throwing an exception that will be caught and execution will proceed"
	Write-Output "World!"
}
catch {
	Write-Error "Caught an exception: $_"
}
"Nice to meet you"

#----------

# Use WhatIf to see what changes would be made without actually making them.
Remove-Item -Path 'C:\Temp\*' -Recurse -WhatIf

#----------

# Put code in your $PROFILE file to have it run every time you start PowerShell.
# code $PROFILE
code $DansProfileFilePath

#----------

# More advanced function with parameter validation and help content, and common parameters via CmdletBinding.
function Write-NameToStream {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false, HelpMessage = "The name to include in the output.")]
		[ValidateSet("Alice", "Bob", "Charlie", "Dan")]
		[string] $Name
	)
	Write-Output "Hello $Name."
	Write-Error "Error stream."
	Write-Warning "Warning stream."
	Write-Information "Information stream (not shown by default)."
	Write-Verbose "Verbose stream (not shown by default)."
	Write-Debug "Debug stream (not shown by default)."
}
Write-NameToStream -Name "Alice"
Write-NameToStream -Name "Edward" # Invalid value
Write-NameToStream -Name "Dan" -Verbose -Debug -InformationAction Continue

$output = Write-NameToStream -Name "Bob" -Verbose -Debug -InformationAction Continue
$output

Write-NameToStream -Name  # Ctrl+Space to see available completions for the Name parameter.

Write-NameToStream -Name "Bob" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

Get-Help Write-NameToStream -Full

#----------

# Process CSV and JSON data easily with Import-Csv and Export-Csv, and Import-Json and Export-Json.
$csvData = Get-Content -Path 'D:\dev\Git\PublicPresentations\DontBashPowerShell\src\Demos\SampleData.csv' | ConvertFrom-Csv
$people = $csvData |
	Where-Object { $_.'First Name' -eq 'Sara' } |
	Select-Object 'First Name', 'Last Name', 'Email'
$people
$people | ConvertTo-Json | Out-File -Path 'C:\Temp\Sara.json' -Encoding UTF8

#----------

# Zip up the temp directory
$sourcePath = 'C:\Temp'
$destinationPath = 'C:\Temp\Subfolder.zip'
Compress-Archive -Path $sourcePath -DestinationPath $destinationPath -Force

# Unzip the file back to a folder
Expand-Archive -Path $destinationPath -DestinationPath 'C:\Temp\Unzipped'

#----------

# Run commands interactively on remote computers using Enter-PSSession.
Enter-PSSession -ComputerName 'Server1.domain.com'


# Run commands on remote computers using Invoke-Command.
$scriptBlock = {
	Write-Output "Hello from $env:COMPUTERNAME"
	[bool] $fileExists = Test-Path -Path 'C:\Temp\SomeFile.txt'
	Write-Output "Does C:\Temp\SomeFile.txt exist? $fileExists"
}
Invoke-Command -ScriptBlock $scriptBlock -ComputerName 'Server1.domain.com', 'Server2.domain.com', 'Server3.domain.com'


# Some commands have built-in remoting capabilities, such as Restart-Computer.
Restart-Computer -ComputerName 'Server1.domain.com', 'Server2.domain.com', 'Server3.domain.com' -Force
