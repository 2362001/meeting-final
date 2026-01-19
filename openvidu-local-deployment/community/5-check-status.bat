set NETWORK_NAME=openvidu-community

docker ps --filter "network=%NETWORK_NAME%" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
docker volume ls --filter "name=openvidu-" --format "table {{.Name}}\t{{.Driver}}"
docker network inspect %NETWORK_NAME% --format "Network: {{.Name}} - {{len .Containers}} containers" 2>nul

pause
