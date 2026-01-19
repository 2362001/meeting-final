@echo off
docker run --rm ^
  --name ingress ^
  --add-host host.docker.internal:host-gateway ^
  -p 1935:1935 ^
  -p 8085:8085 ^
  -p 7895:7895/udp ^
  -v "%~dp0..\ingress.yaml:/etc/ingress.yaml:ro" ^
  -e INGRESS_CONFIG_FILE=/etc/ingress.yaml ^
  docker.io/openvidu/ingress:3.5.0
