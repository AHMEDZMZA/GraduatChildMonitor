@echo off
cd /d "%~dp0"

echo ===================================================
echo   Backend Image Updater & Restart Utility
echo ===================================================
echo.

echo 1. Logging in to Docker Hub...
docker login -u mo7amedsala7 -p dckr_pat_3wK_Y4owp7SwwjQAe1z2vIe_bNs

echo.
echo 2. Stopping current containers...
docker-compose --env-file .env down

echo.
echo 3. Pulling the latest backend image(s) from Docker Hub...
docker-compose --env-file .env pull backend

echo.
echo 4. Starting containers with updated images...
docker-compose --env-file .env up -d

echo.
echo 5. Checking running status...
docker-compose ps

echo.
echo Update completed successfully!
echo Press any key to exit...
pause > nul
