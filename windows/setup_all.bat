@echo off
:: Garante que o script rode com privilégios de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Forcando privilegios de Administrador...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:: Garante que o prompt entenda acentos em português
chcp 64001 >nul

:: Muda o foco para a pasta onde o arquivo .bat está salvo
cd /d "%~dp0"

echo ===================================================
echo    INICIANDO INSTALACAO AUTOMATIZADA DE PROGRAMAS   
echo ===================================================

echo [1/6] Instalando Google Chrome (Silencioso)...
start /wait "" ChromeSetup.exe /silent /install

echo [2/6] Instalando Microsoft Teams (Silencioso)...
start /wait "" MSTeamsSetup.exe --silent

echo [3/6] Instalando ONLYOFFICE (Silencioso)...
start /wait "" ONLYOFFICEDesktopInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART

echo [4/6] Instalando GLPI Agent...
start /wait "" msiexec /i GLPI-Agent-1.7.1-x64.msi /qn /norestart

echo [5/6] Verificando e instalando LibreOffice...
if not exist "LibreOfficeSetup.msi" (
    echo Baixando instalador oficial do LibreOffice...
    set "URL=https://www.libreoffice.org/donate/dl/win-x86_64/7.6.4/en-US/LibreOffice_7.6.4_Win_x64.msi"

    rem Tenta curl (Windows 10+)
    where curl >nul 2>&1
    if %ERRORLEVEL%==0 (
        echo Usando curl...
        curl --fail -L --retry 3 --retry-delay 5 -o "LibreOfficeSetup.msi" "%URL%"
        if %ERRORLEVEL% neq 0 (
            echo Erro: curl falhou com codigo %ERRORLEVEL%.
            del /f /q "LibreOfficeSetup.msi" >nul 2>&1
            set "DLFAILED=1"
        ) else (
            set "DLFAILED=0"
        )
    ) else (
        set "DLFAILED=1"
    )

    rem Fallback para PowerShell caso curl falhe (opcional)
    if "%DLFAILED%"=="1" (
        echo Tentando download via PowerShell...
        powershell -NoProfile -Command "Try { Invoke-WebRequest -Uri '%URL%' -OutFile 'LibreOfficeSetup.msi' -UseBasicParsing -TimeoutSec 300; exit 0 } Catch { exit 1 }"
        if %ERRORLEVEL% neq 0 (
            echo Erro: PowerShell falhou ao baixar o arquivo.
            exit /b 1
        )
    )
)

echo Instalando LibreOffice...
start /wait "" msiexec /i "LibreOfficeSetup.msi" /qn /norestart
if %ERRORLEVEL% neq 0 (
    echo Erro: msiexec retornou %ERRORLEVEL% durante a instalacao.
    exit /b %ERRORLEVEL%
)

echo Instalando LibreOffice...
start /wait "" msiexec /i LibreOfficeSetup.msi /qn /norestart

echo [6/6] Abrindo AnyDesk...
start "" AnyDesk.exe

echo ===================================================
echo                 PROCESSO CONCLUIDO!
echo ===================================================
pause
