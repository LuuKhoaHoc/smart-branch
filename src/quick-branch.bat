@echo off
:: Quick branch creation script for Windows
:: Usage: quick-branch.bat [prefix] [ticket] [description]

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo.
    echo === Quick Git Branch Creator ===
    echo.
    echo Usage: quick-branch.bat [prefix] [ticket] [description]
    echo.
    echo Examples:
    echo   quick-branch.bat feat 86ettxvna add-wallet-ui
    echo   quick-branch.bat bug 123 fix-format-number
    echo.
    echo Supported prefixes: feat, bug, hotfix, sync, refactor, docs, test, chore
    echo.
    goto :end
)

:: Get git username
for /f "tokens=*" %%i in ('git config user.name') do set git_username=%%i
if "!git_username!"=="" (
    echo Error: Git username not found. Please configure: git config user.name "Your Name"
    goto :end
)

:: Convert username to lowercase and replace spaces with hyphens
set username=!git_username: =!
for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set username=!username:%%A=%%A!
)

:: Convert to lowercase (simple approach for common characters)
set username=%username:A=a%
set username=%username:B=b%
set username=%username:C=c%
set username=%username:D=d%
set username=%username:E=e%
set username=%username:F=f%
set username=%username:G=g%
set username=%username:H=h%
set username=%username:I=i%
set username=%username:J=j%
set username=%username:K=k%
set username=%username:L=l%
set username=%username:M=m%
set username=%username:N=n%
set username=%username:O=o%
set username=%username:P=p%
set username=%username:Q=q%
set username=%username:R=r%
set username=%username:S=s%
set username=%username:T=t%
set username=%username:U=u%
set username=%username:V=v%
set username=%username:W=w%
set username=%username:X=x%
set username=%username:Y=y%
set username=%username:Z=z%

:: Set parameters
set prefix=%~1
set ticket=%~2
set description=%~3

:: Replace spaces and special characters in description with hyphens
set description=%description: =-%
set description=%description:/=-%
set description=%description:\=-%
set description=%description:_=-%

:: Create branch name
set branch_name=%prefix%/%username%-%ticket%_%description%

echo.
echo Git username: %git_username%
echo Branch name: %branch_name%
echo.

:: Confirm
set /p confirm="Create branch? (y/N): "
if /i not "%confirm%"=="y" (
    echo Cancelled.
    goto :end
)

:: Check if branch exists
git show-ref --verify --quiet refs/heads/%branch_name% >nul 2>&1
if !errorlevel! equ 0 (
    echo Error: Branch '%branch_name%' already exists!
    goto :end
)

:: Create and checkout branch
echo Creating branch...
git checkout -b %branch_name%
if !errorlevel! equ 0 (
    echo.
    echo ✓ Successfully created and switched to branch '%branch_name%'
    echo.
    echo Remember:
    echo - One PR = One ticket only
    echo - Use git rebase when merging
    echo - Max 400 lines per file
) else (
    echo Error: Failed to create branch '%branch_name%'
)

:end
pause