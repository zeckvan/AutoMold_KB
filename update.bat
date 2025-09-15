@echo off
cd /d D:\AutoMold_KB

:: 取得目前時間，當成 commit 訊息
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set today=%%a-%%b-%%c
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
    set now=%%a-%%b
)

set msg=Auto update on %today% %now%

echo.
echo === Git Auto Update ===
echo Commit message: %msg%
echo.

git add .
git commit -m "%msg%"
git pull origin main
git push origin main

echo.
echo === Done! 已經把最新檔案推送到 GitHub ===
pause
