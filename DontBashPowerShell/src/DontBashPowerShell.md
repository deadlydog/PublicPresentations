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

1. How many of you have used PowerShell before?
1. How many of you have used Bash before?
1. How many of you have programmed in .NET before? e.g. C# or F#

---

## What is PowerShell?

- What do you think PowerShell is? What do you think it's used for?
- Command-line shell
- Scripting language enabling automation
- Developed by Microsoft
- Open-source and cross-platform (Windows, MacOS, Linux)

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
- $PROFILE to run a script at startup to customize your environment (e.g. add aliases, functions, import modules, etc.)
- Extension is `.ps1` for PowerShell scripts, and `.psm1` for modules.

---

## What makes PowerShell awesome?

- Uses objects instead of text parsing.
- Tab completion for cmdlets and parameters.
- Rich set of built-in cmdlets out-of-the-box.
- Tons of community modules available via PowerShell Gallery.
- Loads of documentation and a great, supportive community.

---

## Unintuitive things to watch out for:

- $_ is the built-in pipeline variable. Alias is $PSItem.
- Terminating vs. non-terminating errors. Use try/catch and $ErrorActionPreference to control behavior.
- Automatic unrolling of arrays in certain contexts (e.g. when returning an array)
- Set-StrictMode to enforce stricter coding practices and catch common mistakes.
- ForEach-Object vs. foreach loop differences (e.g. ForEach-Object processes items one at a time, while foreach loop processes all items at once)

---

## Bash

- Script starts with a shebang, `#!/bin/bash`, to specify the interpreter, as has extension `.sh`.
- Uses text-based output, so you often need to use tools like `awk`, `sed`, `grep` to parse output.
- Uses pipes to chain commands together, passing text output from one command to the next.

---

## Comparison examples:

PowerShell has default aliases many (but not all) common Bash commands, such as:

- ls vs. Get-ChildItem
- cat vs. Get-Content
- grep vs. Select-String
- mv vs. Move-Item
- rm vs. Remove-Item
- pwd vs. Get-Location
- echo vs. Write-Output
- touch vs. New-Item -ItemType File
- mkdir vs. New-Item -ItemType Directory
- find vs. Get-ChildItem -Recurse

Use `Get-Alias` to see all aliases, and `Get-Command` to see all cmdlets.

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

## When to use Bash instead of PowerShell:

- Mostly Linux administration tasks, especially if you can't guarantee PowerShell is installed.
- Dockerfiles where you don't want to add PowerShell as a dependency, as it's a larger image

---

## Downsides of PowerShell:

- Requires installation on non-Windows platforms, which can be a barrier in some environments.
- Windows PowerShell vs. PowerShell Core
- Dependency on .NET versions
  - Requires removing old .NET versions when they fall out of support.
