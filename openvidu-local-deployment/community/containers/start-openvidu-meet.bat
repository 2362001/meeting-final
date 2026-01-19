@echo off
docker run --rm ^
  --name openvidu-meet ^
  --add-host host.docker.internal:host-gateway ^
  -p 9080:6080 ^
  -v "%~dp0..\scripts\entrypoint_openvidu_meet.sh:/scripts/entrypoint.sh:ro" ^
  -v "%~dp0..\scripts\utils.sh:/scripts/utils.sh:ro" ^
  -e USE_HTTPS=false ^
  -e LAN_MODE=false ^
  -e LAN_DOMAIN= ^
  -e LAN_PRIVATE_IP= ^
  -e SERVER_PORT=6080 ^
  -e MEET_LOG_LEVEL=info ^
  -e MEET_NAME_ID=openviduMeet-LOCAL ^
  -e MEET_INITIAL_API_KEY=meet-api-key ^
  -e MEET_INITIAL_ADMIN_USER=admin ^
  -e MEET_INITIAL_ADMIN_PASSWORD=admin ^
  -e MEET_COOKIE_SECURE=false ^
  -e MEET_INITIAL_WEBHOOK_ENABLED=true ^
  -e MEET_INITIAL_WEBHOOK_URL=http://host.docker.internal:6080/webhook ^
  -e LIVEKIT_URL_PRIVATE=ws://host.docker.internal:7880/ ^
  -e LIVEKIT_API_KEY=devkey ^
  -e LIVEKIT_API_SECRET=secret ^
  -e MEET_S3_BUCKET=openvidu-appdata ^
  -e MEET_S3_SUBBUCKET=openvidu-meet ^
  -e MEET_S3_SERVICE_ENDPOINT=http://host.docker.internal:9000 ^
  -e MEET_S3_ACCESS_KEY=minioadmin ^
  -e MEET_S3_SECRET_KEY=minioadmin_password_123 ^
  -e MEET_AWS_REGION=us-east-1 ^
  -e MEET_S3_WITH_PATH_STYLE_ACCESS=true ^
  -e MEET_REDIS_HOST=host.docker.internal ^
  -e MEET_REDIS_PORT=6379 ^
  -e MEET_REDIS_PASSWORD=redis_password_123 ^
  -e MEET_REDIS_DB=0 ^
  -e MEET_MONGO_URI=mongodb://admin:mongo_password_123@host.docker.internal:27017/?replicaSet=rs0^&readPreference=primaryPreferred ^
  --entrypoint /bin/sh ^
  docker.io/openvidu/openvidu-meet:3.5.0 ^
  /scripts/entrypoint.sh
