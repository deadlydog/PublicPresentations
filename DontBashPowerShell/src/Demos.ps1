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

# Variables are expanded in double-quoted strings, but not single-quoted strings.
$string1 = "Hello, "
[string] $string2 = "World!"
$string1 + $string2
"$string1$string2"
'$string1$string2'

# Write-Output is implied when you write an expression or variable.
$number1 = 1
[int] $number2 = 2
$number1 + $number2

# Assigning a typed variable with the wrong type results in an error.
[int] $number = "Hello"
$number

# Use Strict Mode to enforce variable declaration and other rules.
$undeclaredVariable
$null -eq $undeclaredVariable

Set-StrictMode -Version Latest
$undeclaredVariable

Set-StrictMode -Off

# See what properties and methods are available on an object, and it's type, using Get-Member.
Get-Process | Get-Member

# See all properties of an object using Select-Object.
Get-Process | Select-Object -First 1
Get-Process | Select-Object -First 1 -Property *

# Filter using Where-Object.
Get-Process |
	Where-Object { $_.WorkingSet -gt 500MB }

# Sort using Sort-Object.
Get-Process |
	? { $_.WorkingSet -gt 500MB } |
	Sort-Object -Property WorkingSet -Descending |
	Select-Object -Property Name, WorkingSet

# See all aliases
Get-Alias
Get-Alias -Name ls
Get-Alias -Definition Get-ChildItem
Set-Alias -Name lucky -Value Get-Random
lucky

# Can add custom properties to any object using Add-Member.
$process = Get-Process | Select-Object -First 1
$process | Add-Member -MemberType NoteProperty -Name "DansProperty" -Value "DansValue"
$process.DansProperty
$process | Get-Member
$process | Select-Object Name, DansProperty

# Can also use calculated properties to add custom properties on the fly.
$process | Select-Object Name, @{Name="DansCalculatedProperty"; Expression={"DansCalculatedValue-" + $_.Name}} -First 1

$process | Select-Object Name, WorkingSet, @{Name = "MemoryInMb"; Expression = { $_.WorkingSet / 1MB } } -First 1

# Will error if you call a function that's not defined yet.
Write-HelloWorld

function Write-HelloWorld {
	Write-Output "Hello, World!"
}

Write-HelloWorld

function Write-Hello ($name) {
	Write-Output "Hello, $name!"
}

Write-Hello "Alice"
Write-Hello -name "Bob"

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

# Make sure you capture or discard output you do not want to return.
function Get-PingSucceeded1 {
	ping.exe google.com
	$? # $? is a special variable that contains the success status of the last command. It will be $true if the ping command succeeded, and $false if it failed.
}
Get-PingSucceeded1

function Get-PingSucceeded2 {
	ping.exe google.com | Out-Null
	$?
}
Get-PingSucceeded2

function Get-PingSucceeded3 {
	$output = ping.exe google.com
	$output -like '*Received = 4*'
}
Get-PingSucceeded3

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
$ErrorActionPreference = "Continue"

# Use WhatIf to see what changes would be made without actually making them.
Remove-Item -Path $PSScriptRoot -WhatIf
