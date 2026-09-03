@echo off
:: Garante que o script rode com privilégios de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Forcando privilegios de Administrador...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

chcp 64001 >nul
cd /d "%~dp0"

echo ===================================================
echo    INICIANDO INSTALACAO AUTOMATIZADA DE PROGRAMAS   
echo ===================================================

:: [1/6] Google Chrome (Verifica se a pasta do Chrome existe)
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    echo [1/6] Google Chrome ja esta instalado. Pulando...
) else (
    echo [1/6] Instalando Google Chrome (Silencioso)...
    start /wait "" ChromeSetup.exe /silent /install
)

:: [2/6] Microsoft Teams (Verifica se a pasta do Teams existe no AppData do usuário ou Program Files)
if exist "%LocalAppData%\Microsoft\Teams" (
    echo [2/6] Microsoft Teams ja esta instalado. Pulando...
) else (
    echo [2/6] Instalando Microsoft Teams (Silencioso)...
    start /wait "" MSTeamsSetup.exe --silent
)

:: [3/6] ONLYOFFICE (Verifica a pasta de instalação)
if exist "C:\Program Files\ONLYOFFICE\DesktopEditors\DesktopEditors.exe" (
    echo [3/6] ONLYOFFICE ja esta instalado. Pulando...
) else (
    echo [3/6] Instalando ONLYOFFICE (Silencioso)...
    start /wait "" ONLYOFFICEDesktopInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
)

:: [4/6] GLPI Agent (Verifica se o serviço ou a pasta do GLPI existe)
if exist "C:\Program Files\GLPI-Agent\glpi-agent.exe" (
    echo [4/6] GLPI Agent ja esta instalado. Pulando...
) else (
    echo [4/6] Instalando GLPI Agent...
    start /wait "" msiexec /i GLPI-Agent-1.7.1-x64.msi /qn /norestart
)

:: [5/6] LibreOffice (Verifica se a pasta principal do LibreOffice existe)
if exist "C:\Program Files\LibreOffice\program\soffice.exe" (
    echo [5/6] LibreOffice ja esta instalado. Pulando...
) else (
    echo [5/6] Baixando e instalando LibreOffice (Silencioso)...
    powershell -Command "Invoke-WebRequest -Uri 'https://download.documentfoundation.org/libreoffice/stable/7.6.4/win/x86_64/LibreOffice_7.6.4_Win_x64.msi' -OutFile 'LibreOfficeSetup.msi'"
    start /wait "" msiexec /i LibreOfficeSetup.msi /qn /norestart
    del LibreOfficeSetup.msi
)

:: [6/6] AnyDesk (Se for executável portátil, apenas abre se não estiver rodando)
tasklist /fi "imagename eq AnyDesk.exe" | find /i "AnyDesk.exe" >nul
if %errorLevel% equ 0 (
    echo [6/6] AnyDesk ja esta em execucao. Pulando...
) else (
    echo [6/6] Abrindo AnyDesk...
    start "" AnyDesk.exe
)

echo ===================================================
echo                 PROCESSO CONCLUIDO!
echo ===================================================
pause
