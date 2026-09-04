@echo off
setlocal EnableExtensions
rem ============================================================
rem  Build and deploy the blog to Cloudflare Pages.
rem  This script lives INSIDE the blog folder and uses only
rem  relative paths (%~dp0), so you can move the folder
rem  anywhere without breaking it.
rem  Requirements on this machine: hugo + nodejs on PATH.
rem ============================================================
set "SITE_DIR=%~dp0"
rem %~dp0 ends with a backslash which breaks quoted args - strip it
if "%SITE_DIR:~-1%"=="\" set "SITE_DIR=%SITE_DIR:~0,-1%"
set "npm_config_registry=https://registry.npmmirror.com"
set "WRANGLER_SEND_METRICS=false"
rem tool locations on this machine, harmless if they do not exist
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\nodejs;C:\Users\rencai\AppData\Local\Microsoft\WinGet\Links;%PATH%"

if exist "%SITE_DIR%\.git" (
    echo [0/3] Committing local changes to git...
    git -C "%SITE_DIR%" add -A
    git -C "%SITE_DIR%" diff --cached --quiet
    if errorlevel 1 git -C "%SITE_DIR%" commit -m "publish: update blog" --quiet
    git -C "%SITE_DIR%" push
) else (
    echo [0/3] Folder is not a git repo, skipping git sync.
)

echo [1/3] Building site with Hugo...
hugo -s "%SITE_DIR%" --minify
if errorlevel 1 (
    echo [ERROR] Hugo build failed. Check your Markdown or hugo.yaml syntax.
    pause
    exit /b 1
)

echo [2/3] Making sure the Pages project exists...
call npx -y wrangler@latest pages project create xbd-blogs --production-branch=main 2>nul

echo [3/3] Deploying to Cloudflare Pages...
call npx -y wrangler@latest pages deploy "%SITE_DIR%\public" --project-name=xbd-blogs --branch=main --commit-dirty=true
if errorlevel 1 (
    echo Direct connection failed, retrying via local proxy 127.0.0.1:7890 ...
    set "HTTPS_PROXY=http://127.0.0.1:7890"
    set "NODE_USE_ENV_PROXY=1"
    call npx -y wrangler@latest pages deploy "%SITE_DIR%\public" --project-name=xbd-blogs --branch=main --commit-dirty=true
    if errorlevel 1 (
        echo [ERROR] Deploy failed. If authorization expired, run once: npx wrangler login
        pause
        exit /b 1
    )
)

echo.
echo DONE! Your blog is live at https://xbd-blogs.pages.dev
if "%~1"=="" pause
