PREREQ_FLAG='/prereq_flag';
if [[ ! -f "$PREREQ_FLAG" ]]; then
    apt-get -y install -qq aria2 && touch "$PREREQ_FLAG";
fi;
if [[ -v CLOUDFLARE_TOKEN ]]; then
    CLOUDFLARE_FLAG='/cloudflare_flag';
    if [[ -f "$CLOUDFLARE_FLAG" ]]; then
        cloudflared service uninstall;
    else
        curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb;
    fi;
    cloudflared service install $CLOUDFLARE_TOKEN && touch "$CLOUDFLARE_FLAG";
else
    curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb;
fi;
MAX_CONNECTIONS=4;
MODEL_FOLDER='/content/models';
MODEL_NAME=$(basename "$MODEL_URL");
if [[ ! -d "$MODEL_FOLDER" ]]; then
    mkdir --parents "$MODEL_FOLDER";
fi;
if [[ ! -f "${MODEL_FOLDER}/${MODEL_NAME}" ]]; then
    aria2c --max-connection-per-server=$MAX_CONNECTIONS --max-concurrent-downloads=$MAX_CONNECTIONS --dir="$MODEL_FOLDER" --out="$MODEL_NAME" "$MODEL_URL";
fi;
if [[ -n "$MMPROJ_URL" ]]; then
    MMPROJ_NAME=$(basename "$MMPROJ_URL");
    if [[ ! -f "${MODEL_FOLDER}/${MMPROJ_NAME}" ]]; then
        aria2c --max-connection-per-server=$MAX_CONNECTIONS --max-concurrent-downloads=$MAX_CONNECTIONS --dir="$MODEL_FOLDER" --out="$MMPROJ_NAME" "$MMPROJ_URL";
    fi;
    UI_ARGS_WITHOUT_MODEL="--mmproj ${MODEL_FOLDER}/${MMPROJ_NAME} ${UI_ARGS_WITHOUT_MODEL}";
fi;
UI_ARGS="--model ${MODEL_FOLDER}/${MODEL_NAME} ${UI_ARGS_WITHOUT_MODEL}";
COMMAND="/llama-server $UI_ARGS";
echo $COMMAND;
if [[ ! -v CLOUDFLARE_TOKEN ]]; then
    echo "Cloudflare token not set, using TryCloudflare quick tunnel." && echo 'Redirecting llama-server output to "/content/llama-server.log" to keep tunnel url on log screen.' && nohup $(eval $COMMAND) >/content/llama-server.log 2>&1 & cloudflared tunnel --url http://localhost:5000;
else
    eval $COMMAND;
fi
