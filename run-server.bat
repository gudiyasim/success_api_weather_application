@echo off
REM Wrapper to run the PowerShell server starter
powershell -ExecutionPolicy Bypass -File "%~dp0run-server.ps1" %1
