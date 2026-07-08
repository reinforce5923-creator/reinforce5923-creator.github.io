@echo off
cd /d "%~dp0"
set /p title=Please enter post title: 
if "%title%"=="" (
  echo Title cannot be empty.
  pause
  exit /b 1
)
npx hexo new post "%title%"
pause
