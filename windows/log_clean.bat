@echo off
set SrcDir=D:\worksoftware\SecureCrt\Log
set DaysAgo=5
forfiles /P %SrcDir% /s /m *.log /d -%DaysAgo% /c "cmd /c del /f /q /a @path"