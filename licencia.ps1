# Cambia el estado de servicio de un BM100 y lo sube a GitHub. El equipo lo lee en la próxima consulta
# (cada 1 hora mientras tenga internet, o al reiniciarse).
#
# Uso (o con licencia.bat):
#   .\licencia.ps1 -Id 30C6F74413E4 -Estado bloqueado -Mensaje "Cuota vencida el 30/11"
#   .\licencia.ps1 -Id 30C6F74413E4 -Estado activo
#   .\licencia.ps1 -Id 30C6F74413E4 -Estado liberado      <- DEFINITIVO: el equipo deja de consultar para siempre
#
# El Id es el que muestra la interfaz en Ajustes -> Versiones y actualizacion -> ID del equipo.
param(
    [Parameter(Mandatory = $true)][ValidatePattern('^[0-9A-F]{12}$')][string]$Id,
    [Parameter(Mandatory = $true)][ValidateSet('activo', 'bloqueado', 'liberado')][string]$Estado,
    [string]$Mensaje = ""
)

$ErrorActionPreference = "Stop"
$repo = $PSScriptRoot

if ($Estado -eq 'liberado') {
    $r = Read-Host "LIBERADO es definitivo: el equipo $Id no va a volver a consultar nunca. Escriba SI para confirmar"
    if ($r -ne 'SI') { Write-Host "Cancelado."; exit 1 }
}

& git -C $repo pull -q
$ruta = Join-Path $repo "licencias\$Id.json"
$contenido = [ordered]@{ estado = $Estado; mensaje = $Mensaje } | ConvertTo-Json
[IO.File]::WriteAllText($ruta, $contenido, (New-Object Text.UTF8Encoding $false))

& git -C $repo add "licencias/$Id.json"
& git -C $repo commit -q -m "Licencia $Id -> $Estado"
& git -C $repo push -q
if ($LASTEXITCODE -ne 0) { throw "No se pudo subir a GitHub" }

Write-Host "Equipo $Id -> $Estado. Lo toma en la proxima consulta (hasta 1 hora, o al reiniciar; GitHub puede demorar hasta 5 minutos en publicarlo)."
