---
marp: true
theme: default
paginate: true # Show page numbers on slides.

---
<!-- Don't show page number on title slide -->
<!-- paginate: skip -->

# Don't Bash, PowerShell!

## An introduction to PowerShell; Why and when to use it

By Daniel Schroeder

---
<!-- paginate: true -->

## About Dan Schroeder

---

## Audience Survey

1. Who has used PowerShell before?
1. Who has used Bash before?
1. Who has not used either PowerShell or Bash before?
1. Who has programmed in .NET before? e.g. C#, F#, VS.NET, PowerShell

---

## What is PowerShell?

- What do you think PowerShell is? What do you think it's used for?
- Command-line shell
- Scripting language enabling automation
- Developed by Microsoft
- Open-source and cross-platform (Windows, MacOS, Linux)

- Easy to get started with, with one-liners
- Eventually stitch those together into scripts
- Later move those into functions
- Finally, create modules to share and reuse code across projects and teams

---

## Terminal vs. Shell

- Terminal is the program that provides the interface for text input and output (e.g. Windows Terminal, iTerm2, etc.)
- Shell is the program that processes commands and provides features like scripting, variables, etc. (e.g. PowerShell, Bash, etc.)

---

## Quick tidbits

- PowerShell is cross-platform (Windows, Linux, macOS).
- PowerShell is built on .NET, and you can use .NET methods.
- Uses Verb-Noun naming convention for cmdlets (e.g., Get-Process, Set-Item).
- Supports both interactive use and scripting.
- Is case insensitive.
- Is object-oriented, meaning it works with objects rather than just text.
- Can be used both dynamically and strongly typed
- Pipeline to allow for chaining commands together, and passing objects downstream before fully processing all objects (similar to `yield return x` in C#)
- Use `$PROFILE` to run a script at startup to customize your environment (e.g. add aliases, functions, import modules, etc.)
- Extension is `.ps1` for PowerShell scripts, and `.psm1` for modules.
- VS Code is the preferred editor for PowerShell script development, with the PowerShell extension providing rich editing features and integrated terminal.
- `Out-GridView`, but is Windows-only. There is a similar `Out-ConsoleGridView` module for Linux and MacOS, but it is not as fully featured.
- Can omit parameter names and use positional parameters

---

## What makes PowerShell awesome?

- Uses objects (properties and methods) instead of text parsing.
- Dynamic and strongly typed, so you can choose the level of type safety you want.
- Can add custom properties and methods to any object on the fly.
- Tab completion for cmdlets and parameters.
- Rich set of built-in cmdlets out-of-the-box.
- Tons of community modules available via PowerShell Gallery.
- Loads of documentation and a great, supportive community.

- Can use PS2EXE module to compile scripts into standalone executables.
- Range operator `..` to create arrays of numbers or characters.

---

- `-like` and `-match` operators for wildcard and regex pattern matching respectively.
- Can interactively run code against a remote server using `Invoke-Command` or `Enter-PSSession`.
- Great for running code against many servers or Virtual Machines at once.

---

## Unintuitive things to watch out for

- $_ is the built-in pipeline variable. Alias is $PSItem.
- Terminating vs. non-terminating errors. Use try/catch and $ErrorActionPreference to control behavior.
- Automatic unrolling of arrays in certain contexts (e.g. when returning an array)
- Set-StrictMode to enforce stricter coding practices and catch common mistakes.
- ForEach-Object vs. foreach loop differences (e.g. ForEach-Object processes items one at a time, while foreach loop processes all items at once)
- Using Select-Object -ExpandProperty to expand properties that are objects or arrays into the pipeline, rather than returning them as nested objects.

---

## Bash

- Script starts with a shebang, `#!/bin/bash`, to specify the interpreter, as has extension `.sh`.
- Uses text-based output, so you often need to use tools like `awk`, `sed`, `grep` to parse output.
- Uses pipes to chain commands together, passing text output from one command to the next.
- Must use associative arrays to create structured data.

```bash
#!/bin/bash

# Declare an associative array
declare -A user

# Assign properties
user[name]="John Doe"
user[id]=12345
user[role]="Admin"

# Access properties
echo "User Name: ${user[name]}"
echo "User ID: ${user[id]}"
echo "User Role: ${user[role]}"
```

---

## Other shells

There are many other shells besides PowerShell and Bash, each with its own features and use cases. Some popular ones include:

- sh (Bourne shell)
- zsh (Z shell)
- fish (Friendly Interactive Shell)
- csh (C shell)
- ksh (Korn shell)
- ...
All, slightly different syntax and features.

Also, some Docker images do not have all tools installed. e.g. the hardened Alpine image does not have include `ls` or `cat`, so you have to use `find` instead. PowerShell's built-in cmdlets are always available, regardless of the underlying OS or image, as long as PowerShell is installed.

---

## Comparison examples

PowerShell has default aliases many (but not all) common Bash commands, such as:

- cls is Clear-Host
- ls is Get-ChildItem
- cat is Get-Content
- less is Get-Content -Wait
- grep is Select-String
- mv is Move-Item
- rm is Remove-Item
- pwd is Get-Location
- echo is Write-Output
- touch is New-Item -ItemType File
- mkdir is New-Item -ItemType Directory
- find is Get-ChildItem -Recurse
- locate is Get-ChildItem -Recurse

Use `Get-Alias` to see all aliases, and `Get-Command` to see all cmdlets.

Can also create your own aliases with `Set-Alias` or functions for more complex behavior.

These are the equivalent commands for common Bash commands that do not share an alias in PowerShell:

- curl vs. Invoke-WebRequest or Invoke-RestMethod
- chmod vs. Set-ACL
- sudo vs. Start-Process -Verb RunAs
- xargs vs. ForEach-Object
- awk/sed vs. -replace operator or regex methods in PowerShell
- diff vs. Compare-Object
- tar vs. Compress-Archive and Expand-Archive

If just calling other CLIs without parsing output, the 2 are very similar; just a series of CLI calls. The differences become more apparent when you need to parse output, as PowerShell's object-oriented nature allows you to work with structured data rather than just text.

---

## Other languages

Show comparisons of PowerShell vs. C#, Ruby, and Python for common tasks, such as:

- Reading/writing files
- Making HTTP requests
- Working with JSON
- Interacting with the filesystem

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

<br />

```powershell
Install-Module -Name tiPS
```
