@echo off
powershell -Command "& {Write-Output 'Start environment...';vagrant up;Write-Output 'Started.';Write-Output 'Closing...';pause;}"