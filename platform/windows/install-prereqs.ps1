Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Host "Install Chocolatey first: https://chocolatey.org/install"
  exit 1
}
choco install -y git python kubernetes-cli kubernetes-helm make jq
Write-Host "Install WSL2/Docker Desktop for Linux containers, or use Windows container nodes for Windows workloads."
