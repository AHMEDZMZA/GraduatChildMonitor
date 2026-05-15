@echo off
cd /d "%~dp0"

echo Logging in to Docker Hub...
docker login -u mo7amedsala7 -p dckr_pat_3wK_Y4owp7SwwjQAe1z2vIe_bNs

echo.
echo Starting containers...
docker-compose --env-file .env up -d

echo.
echo Containers started. Checking status...
docker-compose ps

echo.
echo Press any key to exit...
pause > nul