@echo off
docker run --rm ^
  --name openvidu ^
  --add-host host.docker.internal:host-gateway ^
  -p 3478:3478/udp ^
  -p 7880:7880 ^
  -p 7881:7881/tcp ^
  -p 7900-7999:7900-7999/udp ^
  -v "%~dp0..\livekit.yaml:/etc/livekit.yaml:ro" ^
  -v "%~dp0..\scripts\entrypoint_openvidu.sh:/scripts/entrypoint.sh:ro" ^
  -e LAN_MODE=false ^
  -e LAN_PRIVATE_IP= ^
  --entrypoint /bin/sh ^
  docker.io/openvidu/openvidu-server:3.5.0 ^
  /scripts/entrypoint.sh --config /etc/livekit.yaml
