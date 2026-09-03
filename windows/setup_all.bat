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
    powershell -Command "Invoke-WebRequest -Uri 'https://download.documentfoundation.org/libreoffice/stable/7.6.4/win/x86_64/LibreOffice_7.6.4_Win_x64.msi' -OutFile 'LibreOfficeSetup.msi'"
)
echo Instalando LibreOffice...
start /wait "" msiexec /i LibreOfficeSetup.msi /qn /norestart

echo [6/6] Abrindo AnyDesk...
start "" AnyDesk.exe

echo ===================================================
echo                 PROCESSO CONCLUIDO!
echo ===================================================
pause
