#!/bin/bash

TOKEN="tg bot token "
CHAT_ID=" your chat id"

send_telegram_message() {
    local message="$1"
    curl -s -X POST \
        https://api.telegram.org/bot$TOKEN/sendMessage \
        -d chat_id=$CHAT_ID \
        -d text="$message" \
        -d parse_mode="Markdown"
}

upload_logs() {
    local response=$(cat build_logs.txt | curl -F 'sprunge=<-' http://sprunge.us)
    local url=$(echo "$response" | grep -oP 'https?://\S+')
    send_telegram_message "Fail: Build failed.%0ALogs uploaded successfully.%0ALog URL: $url"
}

send_telegram_message "Your Build has been started!"

bash build.sh > build_logs.txt 2>&1

if [ $? -eq 0 ]; then
    echo "Build completed, notifying on Telegram"
    send_telegram_message "Your Build is successfully completed!"
    echo "Uploading Build!"
    bash scripts/upload.sh
else
    upload_logs
fi
