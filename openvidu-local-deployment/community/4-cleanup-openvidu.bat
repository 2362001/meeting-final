set /p confirm="Type YES to confirm cleanup: "

if /i NOT "%confirm%"=="YES" (
    exit /b 0
)

set NETWORK_NAME=openvidu-community

docker stop openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul
docker rm openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul

docker volume rm openvidu-redis 2>nul
docker volume rm openvidu-minio-data 2>nul
docker volume rm openvidu-minio-certs 2>nul
docker volume rm openvidu-mongo-data 2>nul
docker volume rm openvidu-egress-data 2>nul
docker volume rm openvidu-agents-config 2>nul

docker network rm %NETWORK_NAME% 2>nul

pause
