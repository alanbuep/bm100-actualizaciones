@echo off
rem Cambia el estado de un BM100. Ejemplos:
rem   licencia.bat -Id 30C6F74413E4 -Estado bloqueado -Mensaje "Cuota vencida"
rem   licencia.bat -Id 30C6F74413E4 -Estado activo
rem   licencia.bat -Id 30C6F74413E4 -Estado liberado
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0licencia.ps1" %*
