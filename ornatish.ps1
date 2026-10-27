$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$index = Join-Path $dir 'index.html'
$ico = Join-Path $dir 'planner.ico'

if (-not (Test-Path $index)) {
  Write-Host 'index.html topilmadi. Avval zip faylni to''liq oching (Extract all), keyin qayta ishga tushiring.'
  Read-Host 'Chiqish uchun Enter bosing'
  exit 1
}

$cands = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$browser = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) {
  Write-Host 'Microsoft Edge yoki Google Chrome topilmadi.'
  Read-Host 'Chiqish uchun Enter bosing'
  exit 1
}

$uri = ([System.Uri]$index).AbsoluteUri
$ws = New-Object -ComObject WScript.Shell
$places = @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))
foreach ($p in $places) {
  $lnk = $ws.CreateShortcut((Join-Path $p 'Planner.lnk'))
  $lnk.TargetPath = $browser
  $lnk.Arguments = '--app="' + $uri + '"'
  $lnk.IconLocation = $ico
  $lnk.WorkingDirectory = $dir
  $lnk.Description = 'Kun Rejalashtiruvchi'
  $lnk.Save()
}
Write-Host ''
Write-Host 'Tayyor! Ish stolida va Start menyuda "Planner" belgisi paydo boldi.'
Write-Host 'Muhim: bu papkani boshqa joyga kochirmang va ochirmang.'
Read-Host 'Chiqish uchun Enter bosing'
