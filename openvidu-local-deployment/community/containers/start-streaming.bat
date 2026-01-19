@echo off
docker network inspect openvidu-community >nul 2>&1 || docker network create openvidu-community

set /p choice="Choice (1:Ingress/2:Egress): "

if "%choice%"=="1" (
    docker run --rm ^
      --name ingress ^
      --network openvidu-community ^
      --add-host host.docker.internal:host-gateway ^
      -p 1935:1935 ^
      -p 8085:8085 ^
      -p 7895:7895/udp ^
      -v "%~dp0..\ingress.yaml:/etc/ingress.yaml:ro" ^
      -e INGRESS_CONFIG_FILE=/etc/ingress.yaml ^
      docker.io/openvidu/ingress:3.5.0
) else if "%choice%"=="2" (
    docker volume inspect openvidu-egress-data >nul 2>&1 || docker volume create openvidu-egress-data
    docker run --rm ^
      --name egress ^
      --network openvidu-community ^
      --add-host host.docker.internal:host-gateway ^
      -v "%~dp0..\egress.yaml:/etc/egress.yaml:ro" ^
      -v openvidu-egress-data:/home/egress/tmp ^
      -e EGRESS_CONFIG_FILE=/etc/egress.yaml ^
      docker.io/openvidu/egress:3.5.0
)
