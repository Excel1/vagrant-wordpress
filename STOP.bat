@echo off
powershell -Command "& {Write-Output 'Stop environment...';vagrant halt;Write-Output 'Stopped.';Write-Output 'Closing...';pause;}"