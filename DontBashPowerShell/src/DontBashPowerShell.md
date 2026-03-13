---
marp: true
theme: default
paginate: true # Show page numbers on slides.

---

<style>
  section h1 {
    color: #0078d4;
    border-bottom: 3px solid #0078d4;
    padding-bottom: 8px;
  }

  /* ── Lead / Title slides ── */
  section.lead {
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  section.lead h1 { font-size: 2.6em; border: none; color: #60a5fa; }
  section.lead h2 { font-size: 1.8em; color: #3d70b8; font-weight: 400; }
  section.lead p  { color: #64748b; text-align: right; }

  /* ── Two-column layout ── */
  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-top: 12px;
  }

  .col-ps  { border-left: 4px solid #0078d4; padding-left: 12px; }
  .col-sh  { border-left: 4px solid #4eaa25; padding-left: 12px; }

  .col-ps h3 { color: #1d4ed8; }
  .col-sh h3 { color: #15803d; }
</style>

<!-- _class: lead -->

<!-- Don't show page number on title slide -->
<!-- paginate: skip -->

# ⚡ Don't Bash, PowerShell!

## An introduction to PowerShell and comparison with Bash

<br /><br />

Presented by Daniel Schroeder

---
<!-- paginate: true -->
<!--
style: |
  section.about-slide img[alt="Image of Dan"] {
    position: absolute;
    top: 64px;
    right: 120px;
    width: 400px;
    height: 400px;
    object-fit: cover;
    border-radius: 50%;
  }
-->
<!-- _class: about-slide -->

# About Dan Schroeder

```powershell
$Dan = @{
    Name = 'Daniel Schroeder'
    Alias = 'deadlydog'
    Role = 'Individual Contributor'
    Company = "iQmetrix"
    Address = @{
      City = 'Regina'
      Province = 'Saskatchewan'
      Country = 'Canada'
    }
    Experience = '2+ decades writing code'
    Blog = 'https://blog.danskingdom.com'
    Passions = @('Coding', 'Blogging', 'Automation', 'Dev Productivity Tools')
    Likes = @('.NET', 'PowerShell', 'Knowledge Sharing', 'Dogs', 'Roller Blading')
}
```

![Image of Dan](./Assets/deadlydog-400x400.jpg)

---

# Audience Survey

1. Who has used PowerShell before?
1. Who has used Bash before?
1. Who has not used either PowerShell or Bash before?
1. Who has programmed in .NET before? e.g. C#, F#, VS.NET, PowerShell

---

# What is PowerShell?

- Command-line shell and scripting language
- Created by Microsoft in __2006__; open sourced in __2016__
- Cross-platform (Windows, MacOS, Linux)
- Built on top of .NET and allows access to the .NET libraries

---

# Windows PowerShell vs. PowerShell

<div class="columns">
<div class="col-ps">

### Windows PowerShell

- Windows-only
- Latest version is 5.1
- Built on .NET Framework
- No development; only security updates
- Ships with Windows
- powershell.exe

</div>

<div class="col-ps">

### PowerShell (Core)

- Cross-platform (Windows, Linux, macOS)
- First version was 6.0, latest is currently 7.5
- Built on .NET Core / .NET 5+
- Open source
- Actively developed
- Must be installed
- pwsh.exe

</div>
</div>

---

# What is Bash?

- 🐧 __Bourne Again SHell__ — successor to the original `sh`
- 🐧 Born in __1989__; default shell on most __Linux__ and __macOS__ systems
- 🐧 Passes __plain text strings__ through its pipeline
- 🐧 Deeply integrated with the __Unix toolchain__ (`grep`, `sed`, `awk`, `curl`)
- 🐧 Ubiquitous in __containers__, CI/CD, and server environments
- 🐧 POSIX-compliant — portable across Unix-like systems
- 🐧 Script starts with a shebang, `#!/bin/bash`, and have file extension `.sh`.

---

# The Fundamental Difference

<div class="columns">
<div class="col-ps">

### PowerShell — Objects

```powershell
# Pipeline carries objects with properties
Get-Process |
  Where-Object CPU -gt 10 |
  Select-Object Name, CPU |
  Sort-Object CPU -Descending
```

- Each stage receives **typed objects**
- Filter/sort by **property name** — no parsing
- Output has structured columns automatically

</div>
<div class="col-sh">

### Bash — Text

```bash
# Pipeline carries raw text — must parse manually
ps aux |
  awk '$3 > 10 {print $11, $3}' |
  sort -k2 -rn
```

- Each stage receives **a string of characters**
- Must know exact column positions to extract data
- Output format depends on tool and locale

</div>
</div>

---

# Code Comparison: Variables & Types

<div class="columns">
<div class="col-ps">

### PowerShell

```powershell
# Strongly typed when you want it
[int] $count   = 42
[string] $name = "Alice"

# Rich object types
$date = Get-Date
$date.DayOfWeek  # → "Monday"
$date.Year       # → 2026

# Hashtable
$config = @{ Port = 8080; Debug = $true }
```

</div>
<div class="col-sh">

### Bash

```bash
# Everything is a string
count=42
name="Alice"

# Date is a formatted string
date=$(date)
# Must parse manually to get parts
year=$(date +%Y)    # → "2026"

# Associative array (Bash 4+)
declare -A config
config[Port]=8080
```

</div>
</div>

---

# Code Comparison: Error Handling

<div class="columns">
<div class="col-ps">

### PowerShell

```powershell
# Familiar try/catch/finally
try {
  $data = Get-Content "file.txt" -ErrorAction Stop
  Process-Data $data
}
catch [System.IO.FileNotFoundException] {
  Write-Error "File not found: $_"
}
finally {
  Write-Host "Done"
}
```

- Typed exception classes
- `$?`, `$LASTEXITCODE` for native cmd results

</div>
<div class="col-sh">

### Bash

```bash
# set -e exits on any error
set -e

# Manual error checking
if ! data=$(cat file.txt 2>&1); then
  echo "Error: file not found" >&2
  exit 1
fi

process_data "$data"
echo "Done"
```

- Errors are **silent by default** — must use `set -e`

</div>
</div>

---

# Code Comparison: Working with Files

<div class="columns">
<div class="col-ps">

### PowerShell

```powershell
# List, filter, copy — object-based
Get-ChildItem -Path ./logs -Recurse |
  Where-Object {
    $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
  Copy-Item -Destination ./archive

# Read/write structured data natively
$json = Get-Content config.json | ConvertFrom-Json
$json.version = "2.0"
$json | ConvertTo-Json | Set-Content config.json
```

</div>
<div class="col-sh">

### Bash

```bash
# Find old files and copy — text-based
find ./logs -mtime +30 -type f |
  while read -r file; do
    cp "$file" ./archive/
  done

# Read/write JSON requires jq
version=$(jq -r '.version' config.json)
jq '.version = "2.0"' config.json > tmp.json
mv tmp.json config.json
```

</div>
</div>

---

# What makes PowerShell awesome

- Everything is an object (has properties and methods), not just text
- Uses consistent `Verb-Noun` naming convention (e.g. `Get-Process`, `Set-Item`)
  - [Approved verbs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands) makes cmdlet names predictable and discoverable
- Dynamic or strongly typed, so you can choose the level of type safety you want
- Tab completion for cmdlets and parameters
- Rich set of built-in cmdlets out-of-the-box, plus access to .NET libraries
- Great for running commands on remote machines
- Tons of community modules available via [PowerShellGallery.com](https://www.powershellgallery.com)
- Loads of documentation and a great, supportive community

---

# PowerShell tidbits

- Supports both interactive use and scripting
- Pipeline to allow for chaining commands together, and passing objects downstream before fully processing all objects (similar to `yield return x` in C#)
- Use `$PROFILE` to run a script at startup to customize your environment (e.g. add aliases, functions, import modules, etc.)
- Can add custom properties and methods to any object on the fly
- Can omit parameter names and use positional parameters
- Use the `Pester` module for unit testing
- Can use the `PS2EXE` module to compile scripts into standalone executables

---

# More PowerShell tidbits

- VS Code with the `PowerShell` extension is the recommended IDE
  - Provides syntax highlighting, IntelliSense, debugging, and integrated terminal
- Has many default aliases to make it easier for users coming from other shells
  - `ls` is `Get-ChildItem`
  - `cat` is `Get-Content`
  - `mv` is `Move-Item`
  - `rm` is `Remove-Item`
  - `pwd` is `Get-Location`
  - `echo` is `Write-Output`

---

# Typical learning flow

1. Easy to get started with, with one-liners
1. Eventually stitch those together into scripts (`.ps1` file)
1. Later create functions to reduce duplicate code
1. Finally, create modules to share code across projects and teams (`.psm1` file)

---

# PowerShell operators

```powershell
1 -lt 2   # Less than <
3 -gt 2   # Greater than >
5 -eq 5   # Equal to ==
1 -ne 2   # Not equal to !=
1 -le 1   # Less than or equal to <=
2 -ge 1   # Greater than or equal to >=

"abc" -like "a*"   # Wildcard match
"abc" -match "^a"  # Regex match

$numberArray = 1..10   # Range operator to create an array of numbers

[bool] $isTrue = $true   # Boolean literals
[bool] $isFalse = $false # Requires the $ (i.e. $false, not false)

$isTrue -and $isFalse   # Logical AND
$isTrue -or $isFalse    # Logical OR
```

---

## Unintuitive things to watch out for

- `$_` is the built-in pipeline variable. Alias is `$PSItem`
- Variables are _not_ case-sensitive
- Terminating vs. non-terminating errors. Use try/catch and $ErrorActionPreference to control behavior
- Automatic unrolling of arrays in certain contexts (e.g. when returning an array)
- Set-StrictMode to enforce stricter coding practices and catch common mistakes
- ForEach-Object vs. foreach loop differences (e.g. ForEach-Object processes items one at a time, while foreach loop processes all items at once)
- Using Select-Object -ExpandProperty to expand properties that are objects or arrays into the pipeline, rather than returning them as nested objects

---

- Can interactively run code against a remote server using `Invoke-Command` or `Enter-PSSession`.

- tar vs. Compress-Archive and Expand-Archive

---

## When to use PowerShell

- Automation and scripting tasks
- CI/CD pipelines
- Glueing together different tools and processes
- Interacting with APIs. e.g. Azure CLI, AWS CLI, etc.
  - Modules for Azure, AWS, etc. that provide cmdlets for interacting with their services, which can be easier to work with than their REST APIs or CLI tools.

---

## When to use Bash instead of PowerShell

- Mostly Linux administration tasks, especially if you can't guarantee PowerShell is installed.
- Dockerfiles where you don't want to add PowerShell as a dependency, as it's a larger image.
- When it makes sense. e.g. it's a team/company standard, or existing code base is already Bash.

It's great to know _BOTH_ PowerShell and Bash!

---

## When to use C# (or other) instead of PowerShell

- For more complex applications, especially those that require a GUI or need to be compiled for performance.
- When you want to create a reusable library or API that can be consumed by other applications.

---

## Downsides of PowerShell

- Requires installation on non-Windows platforms, which can be a barrier in some environments.
- Windows PowerShell vs. PowerShell Core
- Dependency on .NET versions
  - Requires removing old .NET versions when they fall out of support.
- No compiler, so typos and syntax errors are often only caught at runtime.

---

## Demos

Do the first 15 - 20 minutes as a presentation, then 15 - 20 minutes of demos

- `Get-Alias` to see all aliases
- `Get-Command` to see all cmdlets and what module they belong to
- Select-Object -First 10
- `Select-Object -Property Name, Version` to select specific properties of an object
- Select-Object -Property *
  - `select *` as shorthand
- `Select-Object -ExpandProperty` to expand a property that is an object or array into the pipeline
- `Select-Object -GroupBy` to group objects by a property and perform aggregate operations on them
  - Do a Sort before GroupBy so that it sorts then groups, otherwise you might end up with a lot of groups as it streams results to the GroupBy cmdlet. (filter left, format right)
- Format-Table vs. Format-List to control how output is displayed
- Select-String to search for text in files or output. Use `-AllMatches` to find all matches in a line.
  - Can also be ran against a directory and it will search all files in that directory and subdirectories.
- `Out-GridView -PassThru` to select items from a list of objects and pass them downstream in the pipeline.

---

What is the difference between these two code snippets?

```powershell
Get-Process | Select-String 'chrome' | Select-Object -First 10
```

```powershell
ps | sls 'chrome' | select -First 10
```

Nothing, they are equivalent.

---

## Splatting

```powershell
Send-MailMessage -To me@mydomain.com -From me@mydomain.com -Subject "Hi" `
    -Body "Hello" -SmtpServer smpthost -ErrorAction SilentlyContinue
```

```powershell
$MailMessage = @{
    To = "me@mycompany.com"
    From = "me@mycompany.com"
    Subject = "Hi"
    Body = "Hello"
    Smtpserver = "smtphost"
    ErrorAction = "SilentlyContinue"
}

Send-MailMessage @MailMessage
```

---

## Installing modules

Super easy to install modules from the PowerShell Gallery: https://www.powershellgallery.com

```powershell
Install-Module -Name tiPS
```

<br />

Update them easily too:

```powershell
Update-Module -Name tiPS
```

---

# Awesome modules

- Posh-Git - Git prompt status and tab completion for Git commands.
- ImportExcel - Read and write Excel files without needing Excel installed.
- tiPS - Get a PowerShell tip in your terminal every day or week.
- Pester - Unit testing framework for PowerShell.
- PSReadLine - Enhanced command-line editing experience with syntax highlighting, multi-line editing, and more.
