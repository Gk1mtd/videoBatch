#!/bin/bash

# Function to convert a video file and keep only the smaller one
function convert_video() {
    local FILE="$1"
    local DIRECTORY=$(dirname "$FILE")
    local FILENAME=$(basename "$FILE")
    local OUTPUT_FILENAME="$DIRECTORY/converted_${FILENAME%.*}.$OUTPUT_FORMAT"

    # Use FFmpeg to convert the video file and set the output resolution
    ffmpeg -y -i "$FILE" -vf "scale=$OUTPUT_RESOLUTION" "$OUTPUT_FILENAME"
    # Check the sizes of the original and converted files
    local CONVERTED_SIZE=$(du -b "$OUTPUT_FILENAME" | awk '{print $1}')
    local ORIGINAL_SIZE=$(du -b "$FILE" | awk '{print $1}')

    # Keep only the smaller file
    if [[ $ORIGINAL_SIZE -gt $CONVERTED_SIZE ]]; then
        if [[ $DELETE_ORIGINAL_FILES == "true" ]]; then
            gio trash "$FILE"
        fi
    else
        gio trash "$OUTPUT_FILENAME"
    fi
}

# Function to recursively convert videos in a directory
function convert_videos_in_directory() {
    local DIRECTORY="$1"

    # Loop through all files and directories within the given directory
    for FILE in "$DIRECTORY"/*; do
        if [ -f "$FILE" ]; then
            # If the current item is a file, check if it's a video file with supported extensions and convert it
            if [[ "$FILE" == *.mp4 || "$FILE" == *.webm || "$FILE" == *.mov || "$FILE" == *.avi || "$FILE" == *.m4v ]]; then
                convert_video "$FILE"
            fi
        elif [ -d "$FILE" ]; then
            # If the current item is a directory, recursively convert videos within it
            convert_videos_in_directory "$FILE"
        fi
    done
}

# Function to choose the quality of conversion using Zenity
function choose_quality() {
    local quality=$(zenity \
        --list \
        --title="Choose Quality" \
        --text="Select the desired conversion quality:" \
        --height="300" \
        --column="Quality" "Low" "Medium" "HD" "4k")

    case $quality in
    "Low")
        OUTPUT_RESOLUTION="640x480"
        OUTPUT_FORMAT="mp4"
        ;;
    "Medium")
        OUTPUT_RESOLUTION="1280x720"
        OUTPUT_FORMAT="mp4"
        ;;
    "HD")
        OUTPUT_RESOLUTION="1920x1080"
        OUTPUT_FORMAT="mkv"
        ;;
    "4k")
        OUTPUT_RESOLUTION="4096x2304"
        OUTPUT_FORMAT="mkv"
        ;;
    *)
        zenity --error --text="Invalid selection."
        exit 1
        ;;
    esac
}

# Function to select a directory using Zenity
function choose_directory() {
    local DIRECTORY=$(zenity --file-selection --directory --title="Select a directory")
    if [[ -n "$DIRECTORY" ]]; then
        choose_quality

        # Ask if old files larger than the new ones should be deleted
        answer=$(zenity --list --title="Delete Files" --text="Delete original files, if they are bigger?" \
            --radiolist --column "" --column "Choice" TRUE "Yes" FALSE "No")

        case $answer in
        "Yes")
            DELETE_ORIGINAL_FILES="true"
            ;;
        "No")
            DELETE_ORIGINAL_FILES="false"
            ;;
        *)
            zenity --error --text="Invalid selection."
            exit 1
            ;;
        esac

        convert_videos_in_directory "$DIRECTORY"
        zenity --info --text="Video conversion completed."
    else
        zenity --error --text="No directory selected."
    fi
}

# Main function
function main() {
    choose_directory
}

# Run the main function
main
