#!/bin/bash

# Function to display Pac-Man progress bar
pacman_progress() {
    local width=50
    local progress=$((($1 * $width) / $2))
    local remaining=$((width - progress))
    printf "["
    printf "%0.s█" $(seq 1 $progress)
    printf "%0.s " $(seq 1 $remaining)
    printf "] %d%%\r" $((($1 * 100) / $2))
}

# Check if file path is provided as argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

# Assign the file path provided as argument to a variable
file_path=$1

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "File not found: $file_path"
    exit 1
fi

# Get the total size of the file
file_size=$(wc -c < "$file_path")

# Initialize variables for progress tracking
progress=0

# Make the GET request to retrieve server information
server_info=$(curl -s -X GET 'https://api.gofile.io/servers')

# Extract the server name
server=$(echo "$server_info" | jq -r '.data.servers[0].name')

# Check if the server name is empty
if [ -z "$server" ]; then
    echo "Failed to get the server name."
    exit 1
fi

# Upload the file using the server name
upload_result=$(curl --progress-bar -X POST "https://$server.gofile.io/contents/uploadfile" -F "file=@$file_path" | tee /dev/stderr | wc -c)

# Extract and print the download link
download_link=$(echo "$upload_result" | jq -r '.data.downloadPage')

# Check if the download link is empty
if [ -z "$download_link" ]; then
    echo "Failed to get the download link."
    exit 1
fi

# Print the download link
echo "Download link: $download_link"
