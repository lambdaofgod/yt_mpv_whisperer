#!/bin/bash

video_file="file.mp4"
sub_file="subtitles.vtt"

prepare_subtitles() {
    video_file=$1
    sub_file_whisper="transcription_whisper.txt"
    sub_file=$2

    # Transcribe the video with OpenAI whisper
    echo "extracting transcription with whisper"
    whisper $video_file --model medium > $sub_file_whisper

    echo "extracted transcription with whisper"
    # Prepare vtt format subtitles
    sed 1,2d -i $sub_file_whisper
    python whisper_subtitles_to_vtt.py $sub_file_whisper $sub_file
    echo "prepare subtitles in VTT format"
}

main() {
    video_file=$1
    sub_file=$2
    rm $video_file
    # Download the youtube video with youtube-dl
    echo "downloading video"
    yt-dlp -o "$video_file" "$youtube_link" -S res,ext:mp4:m4a --recode mp4
    echo "downloaded video"

    prepare_subtitles $video_file $sub_file

    # Use MPV to play the video with the transcription as subtitles
    mpv --sub-file=$sub_file "$video_file"
}

# Set the youtube video link
if [[ "$#" -eq 1 ]];
then
  echo "Downloading $1"
  youtube_link=$1
else
  echo "You didn't specify URL, preparing a surprise"
  youtube_link="https://www.youtube.com/watch?v=dQw4w9WgXcQ"
fi

main $video_file $sub_file
