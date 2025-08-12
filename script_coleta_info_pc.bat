@echo off
echo.
	REM Hostname
echo Hostname da Maquina:
	hostname
echo.

echo Dominio ou Grupo de Trabalho:
    wmic /node:"%target%" computersystem get domain
echo.

echo Serial Number:
    wmic /node:"%target%" bios get serialnumber
echo.

echo MEMORIA RAM (GB):
	REM total em GB
	for /f "skip=1 tokens=2 delims==" %%A in ('wmic OS get TotalVisibleMemorySize /Value') do set TotalMemKB=%%A
	set /a TotalMemGB=%TotalMemKB% / 1024 / 1024
	echo Memoria RAM Total: %TotalMemGB% GB

	REM usada em GB
	for /f "skip=1 tokens=2 delims==" %%A in ('wmic OS get FreePhysicalMemory /Value') do set FreeMemKB=%%A
	set /a UsedMemKB=%TotalMemKB% - %FreeMemKB%
	set /a UsedMemGB=%UsedMemKB% / 1024 / 1024
	echo Memoria RAM Usada: %UsedMemGB% GB
echo.
	
	
echo MEMORIA SSD (GB): 
	REM --- Disco C ---
		for /f "skip=1 tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value') do (
    			if not "%%a"=="" set size=%%a
		)

		for /f "skip=1 tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value') do (
    			if not "%%a"=="" set free=%%a
		)

	REM --- Calcular usando PowerShell para evitar limite de 32 bits ---
		for /f %%a in ('powershell -command "[math]::Round(%size%/1GB,2)"') do set sizeGB=%%a
		for /f %%a in ('powershell -command "[math]::Round(%free%/1GB,2)"') do set freeGB=%%a
		for /f %%a in ('powershell -command "[math]::Round((%size% - %free%)/1GB,2)"') do set usedGB=%%a

	echo Disco C: Total: %sizeGB% GB
	echo Disco C: Usado: %usedGB% GB
	echo Disco C: Livre: %freeGB% GB
echo.
echo.

echo Processador:
    wmic /node:"%target%" cpu get name
echo.


echo Sistema Operacional:
    wmic /node:"%target%" os get caption,version
echo.

echo Verificando processo msbv (indicativo do Buran):
    wmic /node:"%target%" process where name="msbv.exe" get name
echo.

echo Desenvolvido por: Gessivan Junior - Tecnologia 
echo.
pause