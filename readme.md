# Video Converter

This script is a bash script that allows you to convert video files in a directory (and subdirectories) to a desired quality and format using FFmpeg. It provides a simple and user-friendly interface using Zenity for selecting the conversion quality, choosing the input directory, and deleting original files if they are bigger than the converted ones.

## Prerequisites

- FFmpeg: Make sure FFmpeg is installed on your system.
- Zenity: Zenity is used for creating graphical dialogs in the script. Make sure Zenity is installed on your system.

## Usage

1. Run the script by executing the following command:
   ```
   bash video_converter.sh
   ```

## Instructions

1. When the script starts, a Zenity dialog will appear asking you to select a directory.
2. Browse and select the directory containing the video files you want to convert.
3. Another Zenity dialog will appear, allowing you to choose the desired conversion quality (Low, Medium, HD, 4k). Select the desired quality and click "OK".
4. A confirmation dialog will ask if you want to delete the original files if they are bigger than the converted ones. Choose "Yes" or "No" and click "OK".
5. The script will then convert all the video files in the selected directory and its subdirectories to the specified quality and format (mp4 or mkv for large files) using FFmpeg.
6. Once the conversion is completed, a final Zenity dialog will inform you that the video conversion has finished.

Note: The script only supports video files with the following extensions: .mp4, .webm, .mov, .avi, .m4v.

## Customization

You can customize the script by modifying the following variables:

- `OUTPUT_RESOLUTION`: Set the output resolution for the converted videos. Modify the values in the `choose_quality` function according to your preferences.
- `OUTPUT_FORMAT`: Set the output format for the converted videos. Modify the values in the `choose_quality` function according to your preferences.
