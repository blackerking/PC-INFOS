@echo off
setlocal
cd /d %~dp0
set current_dir=%cd%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%current_dir%\PC-INFOS.ps1'" -allusers