#!/usr/bin/env bats

OUTPUT_DIR="tmp/test/"

setup() {
  mkdir -p $OUTPUT_DIR
}

teardown() {
  rm -r $OUTPUT_DIR
}

@test "remove-silence exists and is executable" {
  run command -v bin/remove-silence
  [ "$status" -eq 0 ]
  [ -x "$(command -v bin/remove-silence)" ]
}

@test "remove-silence shows usage information with -h option" {
  run bin/remove-silence -h
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Usage: "* ]]
}

@test "remove-silence requires input file" {
  run bin/remove-silence
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: Input file is required" ]]
}

@test "remove-silence checks if input file exists" {
  run bin/remove-silence nonexistent.mp4
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: Input file 'nonexistent.mp4' does not exist" ]]
}

@test "remove-silence accepts valid mode options" {
  run bin/remove-silence -m remove tests/test_silence_video.mp4
  [ "$status" -eq 0 ]
  run bin/remove-silence -m fastforward tests/test_silence_video.mp4
  [ "$status" -eq 0 ]
}

@test "remove-silence removes silence from a video" {
  run bin/remove-silence -o $OUTPUT_DIR tests/test_silence_video.mp4
  [ "$status" -eq 0 ]

  # Check that output file is not empty
  run stat -f%z $OUTPUT_DIR/test_silence_video_silence_removed.mp4
  [ "$output" -gt 0 ]

  # Check that output file has the correct duration
  run ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $OUTPUT_DIR/test_silence_video_silence_removed.mp4
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^29\.9[0-9]*$ ]]
}

@test "remove-silence rejects invalid mode options" {
  run bin/remove-silence -m invalid_mode tests/test_silence_video.mp4
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: Invalid mode. Use 'remove' or 'fastforward'." ]]
}

# Add more specific tests here based on the functionality of remove-silence
