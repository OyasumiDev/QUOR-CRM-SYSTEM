<#
Creates the initial folder structure for the ERP desktop monorepo.
It is safe to run repeatedly: existing files are preserved unless -Force is used.

Usage:
  powershell -ExecutionPolicy Bypass -File .\create-erp-structure.ps1
  powershell -ExecutionPolicy Bypass -File .\create-erp-structure.ps1 -Force
#>
[CmdletBinding()]
param(
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path

$directories = @(
  'apps/desktop/src/main',
  'apps/desktop/src/preload',
  'apps/desktop/src/renderer',
  'apps/erp/src/app/core',
  'apps/erp/src/app/shared',
  'apps/erp/src/app/features/catalogs',
  'apps/erp/src/app/features/commercial',
  'apps/erp/src/app/features/projects',
  'apps/erp/src/app/features/finance',
  'apps/erp/src/app/features/purchasing',
  'apps/erp/src/app/features/inventory',
  'apps/erp/src/app/features/people-assets',
  'apps/erp/src/app/features/analytics',
  'packages/domain/src',
  'packages/ui/src',
  'packages/contracts/src',
  'supabase/migrations',
  'supabase/functions',
  'docker',
  'docs/architecture',
  'docs/decisions',
  '.github/workflows',
  '.vscode'
)

$files = @{
  '.gitignore' = @'
node_modules/
dist/
.angular/
.env
.env.*
!.env.example
supabase/.temp/
'@
  'README.md' = @'
# ERP Desktop

Monorepo para un ERP de escritorio: Electron, Angular y Supabase.
'@
  'apps/erp/src/app/features/README.md' = @'
# MÃ³dulos de negocio

Cada mÃ³dulo contiene sus pÃ¡ginas, componentes, aplicaciÃ³n, dominio, acceso a datos y rutas.
'@
  'supabase/seed.sql' = @'
-- Datos de desarrollo. No incluir secretos ni datos de producciÃ³n.
'@
  'docker/README.md' = @'
# Docker

AquÃ­ vive Docker Compose y sus configuraciones de desarrollo reproducible.
'@
  'docs/architecture/README.md' = @'
# Arquitectura

Diagramas, lÃ­mites de mÃ³dulos y decisiones tÃ©cnicas.
'@
  '.github/workflows/README.md' = @'
# AutomatizaciÃ³n

Flujos de validaciÃ³n, pruebas, compilaciÃ³n y distribuciÃ³n.
'@
  '.vscode/extensions.json' = @'
{
  "recommendations": [
    "angular.ng-template",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-azuretools.vscode-docker"
  ]
}
'@
}

foreach ($directory in $directories) {
  New-Item -ItemType Directory -Force -Path (Join-Path $root $directory) | Out-Null
}

foreach ($entry in $files.GetEnumerator()) {
  $file = Join-Path $root $entry.Key
  if ((Test-Path -LiteralPath $file) -and -not $Force) {
    Write-Host "Preserved existing file: $($entry.Key)"
    continue
  }
  Set-Content -LiteralPath $file -Value $entry.Value -Encoding utf8
  Write-Host "Created: $($entry.Key)"
}

Write-Host "`nERP structure ready at: $root"
Write-Host 'Next: initialize Git, create the Angular app, configure Electron, then initialize Supabase locally.'


