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

## What is PowerShell?

---

Another page


Quick tidbits:
- PowerShell is cross-platform (Windows, Linux, macOS).
- PowerShell is built on .NET, which allows for powerful scripting and automation capabilities.
- Uses Verb-Noun naming convention for cmdlets (e.g., Get-Process, Set-Item).
- Supports both interactive use and scripting.
- Is case insensitive.
- Is object-oriented, meaning it works with objects rather than just text.
- Can be used both dynamically and strongly typed
- Pipeline to allow for chaining commands together, and passing objects downstream before fully processing all objects (similar to `yield return x` in C#)



Unintuitive things to watch out for:
- $_ is the built-in pipeline variable. Alias is $PSItem.
- Terminating vs. non-terminating errors. Use try/catch and $ErrorActionPreference to control behavior.
- Automatic unrolling of arrays in certain contexts (e.g. when returning an array)
- Set-StrictMode to enforce stricter coding practices and catch common mistakes.
- ForEach-Object vs. foreach loop differences (e.g. ForEach-Object processes items one at a time, while foreach loop processes all items at once)



Comparison examples:
- curl vs. Invoke-WebRequest or Invoke-RestMethod
- ls vs. Get-ChildItem
- cat vs. Get-Content
- grep vs. Select-String
- xargs vs. ForEach-Object
- find vs. Get-ChildItem -Recurse


When to use Bash instead of PowerShell:
- Mostly Linux administration tasks, especially if you can't guarantee PowerShell is installed.
- Dockerfiles where you don't want to add PowerShell as a dependency, as it's a larger image


Downsides of PowerShell:
- Requires installation on non-Windows platforms, which can be a barrier in some environments.
- Windows PowerShell vs. PowerShell Core
- Dependency on .NET versions
  - Requires removing old .NET versions when they fall out of support.
