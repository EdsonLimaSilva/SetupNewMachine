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

echo [5/6] Instalando LibreOffice via Winget...
start /wait "" winget install --id TheDocumentFoundation.LibreOffice --silent --accept-source-agreements --accept-package-agreements

echo [6/6] Abrindo AnyDesk...
start "" AnyDesk.exe

echo ===================================================
echo                 PROCESSO CONCLUIDO!
echo ===================================================
pause
