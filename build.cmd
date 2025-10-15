@echo off
REM --- build.cmd ---
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
