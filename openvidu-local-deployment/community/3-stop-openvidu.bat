docker stop openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul

set /p choice="Delete containers? (Y/N): "

if /i "%choice%"=="Y" (
    docker rm openvidu-meet caddy-proxy operator dashboard ingress egress openvidu minio mongo redis 2>nul
)

pause
