set NETWORK_NAME=openvidu-community
set REDIS_PASSWORD=redis_password_123
set MONGO_ADMIN_USERNAME=admin
set MONGO_ADMIN_PASSWORD=mongo_password_123
set MINIO_ACCESS_KEY=minioadmin
set MINIO_SECRET_KEY=minioadmin_password_123
set DASHBOARD_ADMIN_USERNAME=admin
set DASHBOARD_ADMIN_PASSWORD=admin
set LIVEKIT_API_KEY=devkey
set LIVEKIT_API_SECRET=secret
set MEET_INITIAL_ADMIN_USER=admin
set MEET_INITIAL_ADMIN_PASSWORD=admin
set MEET_INITIAL_API_KEY=meet-api-key
set USE_HTTPS=false
set LAN_MODE=false
set LAN_DOMAIN=
set LAN_PRIVATE_IP=

docker run -d --name redis --network %NETWORK_NAME% --restart unless-stopped -p 6379:6379 -v openvidu-redis:/data docker.io/redis:8.2.2-alpine redis-server --bind 0.0.0.0 --requirepass %REDIS_PASSWORD%

docker run -d --name mongo --network %NETWORK_NAME% --restart unless-stopped -p 27017:27017 -v openvidu-mongo-data:/bitnami/mongodb -e MONGODB_ROOT_USER=%MONGO_ADMIN_USERNAME% -e MONGODB_ROOT_PASSWORD=%MONGO_ADMIN_PASSWORD% -e MONGODB_ADVERTISED_HOSTNAME=mongo -e MONGODB_REPLICA_SET_MODE=primary -e MONGODB_REPLICA_SET_NAME=rs0 -e MONGODB_REPLICA_SET_KEY=devreplicasetkey docker.io/openvidu/mongodb:8.0.15-r0

docker run -d --name minio --network %NETWORK_NAME% --restart unless-stopped -p 9000:9000 -v openvidu-minio-data:/bitnami/minio/data -v openvidu-minio-certs:/certs -e MINIO_ROOT_USER=%MINIO_ACCESS_KEY% -e MINIO_ROOT_PASSWORD=%MINIO_SECRET_KEY% -e MINIO_DEFAULT_BUCKETS=openvidu-appdata -e MINIO_CONSOLE_SUBPATH=/minio-console -e MINIO_BROWSER=on -e MINIO_BROWSER_REDIRECT_URL=http://localhost:7880/minio-console docker.io/openvidu/minio:2025.9.7-debian-12-r3

timeout /t 5 /nobreak >nul

docker run -d --name openvidu --network %NETWORK_NAME% --restart unless-stopped --add-host host.docker.internal:host-gateway -p 3478:3478/udp -p 7881:7881/tcp -p 7900-7999:7900-7999/udp -v "%~dp0livekit.yaml:/etc/livekit.yaml:ro" -v "%~dp0scripts\entrypoint_openvidu.sh:/scripts/entrypoint.sh:ro" -e LAN_MODE=%LAN_MODE% -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% --entrypoint /bin/sh docker.io/openvidu/openvidu-server:3.5.0 /scripts/entrypoint.sh --config /etc/livekit.yaml

docker run -d --name dashboard --network %NETWORK_NAME% --restart unless-stopped -e SERVER_PORT=5000 -e ADMIN_USERNAME=%DASHBOARD_ADMIN_USERNAME% -e ADMIN_PASSWORD=%DASHBOARD_ADMIN_PASSWORD% -e DATABASE_URL=mongodb://%MONGO_ADMIN_USERNAME%:%MONGO_ADMIN_PASSWORD%@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred docker.io/openvidu/openvidu-dashboard:3.5.0

docker run -d --name operator --network %NETWORK_NAME% --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v openvidu-agents-config:/agents-config -v "%~dp0:/deployment:ro" -e MODE=agent-manager-local -e DEPLOYMENT_FILES_DIR=/deployment -e AGENTS_CONFIG_DIR=/agents-config -e NETWORK_NAME=%NETWORK_NAME% -e AGENTS_CONFIG_VOLUME=openvidu-agents-config -e LIVEKIT_URL=ws://openvidu:7880/ -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% -e REDIS_ADDRESS=redis:6379 -e REDIS_PASSWORD=%REDIS_PASSWORD% docker.io/openvidu/openvidu-operator:3.5.0

docker run -d --name caddy-proxy --network %NETWORK_NAME% --restart unless-stopped --add-host host.docker.internal:host-gateway -p 5443:5443 -p 6443:6443 -p 7443:7443 -p 7880:7880 -p 9443:9443 -v "%~dp0custom-layout:/var/www/custom-layout:ro" -e LAN_DOMAIN=%LAN_DOMAIN% -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% -e LAN_MODE=%LAN_MODE% -e USE_HTTPS=%USE_HTTPS% -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% -e DASHBOARD_ADMIN_USERNAME=%DASHBOARD_ADMIN_USERNAME% -e DASHBOARD_ADMIN_PASSWORD=%DASHBOARD_ADMIN_PASSWORD% -e MINIO_ACCESS_KEY=%MINIO_ACCESS_KEY% -e MINIO_SECRET_KEY=%MINIO_SECRET_KEY% -e MEET_INITIAL_ADMIN_USER=%MEET_INITIAL_ADMIN_USER% -e MEET_INITIAL_ADMIN_PASSWORD=%MEET_INITIAL_ADMIN_PASSWORD% -e MEET_INITIAL_API_KEY=%MEET_INITIAL_API_KEY% docker.io/openvidu/openvidu-caddy-local:3.5.0

docker run -d --name openvidu-meet --network %NETWORK_NAME% --restart on-failure --add-host host.docker.internal:host-gateway -p 9080:6080 -v "%~dp0scripts\entrypoint_openvidu_meet.sh:/scripts/entrypoint.sh:ro" -v "%~dp0scripts\utils.sh:/scripts/utils.sh:ro" -e USE_HTTPS=%USE_HTTPS% -e LAN_MODE=%LAN_MODE% -e LAN_DOMAIN=%LAN_DOMAIN% -e LAN_PRIVATE_IP=%LAN_PRIVATE_IP% -e SERVER_PORT=6080 -e MEET_LOG_LEVEL=info -e MEET_NAME_ID=openviduMeet-LOCAL -e MEET_INITIAL_API_KEY=%MEET_INITIAL_API_KEY% -e MEET_INITIAL_ADMIN_USER=%MEET_INITIAL_ADMIN_USER% -e MEET_INITIAL_ADMIN_PASSWORD=%MEET_INITIAL_ADMIN_PASSWORD% -e MEET_COOKIE_SECURE=false -e MEET_INITIAL_WEBHOOK_ENABLED=true -e MEET_INITIAL_WEBHOOK_URL=http://host.docker.internal:6080/webhook -e LIVEKIT_URL_PRIVATE=ws://openvidu:7880/ -e LIVEKIT_API_KEY=%LIVEKIT_API_KEY% -e LIVEKIT_API_SECRET=%LIVEKIT_API_SECRET% -e MEET_S3_BUCKET=openvidu-appdata -e MEET_S3_SUBBUCKET=openvidu-meet -e MEET_S3_SERVICE_ENDPOINT=http://minio:9000 -e MEET_S3_ACCESS_KEY=%MINIO_ACCESS_KEY% -e MEET_S3_SECRET_KEY=%MINIO_SECRET_KEY% -e MEET_AWS_REGION=us-east-1 -e MEET_S3_WITH_PATH_STYLE_ACCESS=true -e MEET_REDIS_HOST=redis -e MEET_REDIS_PORT=6379 -e MEET_REDIS_PASSWORD=%REDIS_PASSWORD% -e MEET_REDIS_DB=0 -e MEET_MONGO_URI=mongodb://%MONGO_ADMIN_USERNAME%:%MONGO_ADMIN_PASSWORD%@mongo:27017/?replicaSet=rs0^&readPreference=primaryPreferred --entrypoint /bin/sh docker.io/openvidu/openvidu-meet:3.5.0 /scripts/entrypoint.sh

docker run -d --name ingress --network %NETWORK_NAME% --restart unless-stopped --add-host host.docker.internal:host-gateway -p 1935:1935 -p 8085:8085 -p 7895:7895/udp -v "%~dp0ingress.yaml:/etc/ingress.yaml:ro" -e INGRESS_CONFIG_FILE=/etc/ingress.yaml docker.io/openvidu/ingress:3.5.0

docker run -d --name egress --network %NETWORK_NAME% --restart unless-stopped --add-host host.docker.internal:host-gateway -v "%~dp0egress.yaml:/etc/egress.yaml:ro" -v openvidu-egress-data:/home/egress/tmp -e EGRESS_CONFIG_FILE=/etc/egress.yaml docker.io/openvidu/egress:3.5.0

docker ps --filter "network=%NETWORK_NAME%"
pause
