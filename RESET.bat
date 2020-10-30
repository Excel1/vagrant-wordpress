@echo off
powershell -Command "& {Write-Output 'Reset environment...';vagrant destroy -f;Write-Output 'Reset done.';Write-Output 'Closing...';pause;}"