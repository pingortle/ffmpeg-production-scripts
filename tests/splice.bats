#!/usr/bin/env bats

OUTPUT_DIR="tmp/test/"

setup() {
  mkdir -p $OUTPUT_DIR
}

teardown() {
  if [ -d $OUTPUT_DIR ]; then
    rm -r $OUTPUT_DIR
  fi
}

@test "splice shows help message with -h option" {
  run bin/splice -h
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Usage: splice [OPTIONS] FILE1 FILE2 [FILE3 ...]" ]]
}

@test "splice requires at least two input files" {
  run bin/splice input1.mp4
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: At least two input files are required." ]]
}

@test "splice checks if input files exist" {
  run bin/splice nonexistent1.mp4 nonexistent2.mp4
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: File not found: nonexistent1.mp4" ]]
}

@test "splice splices two videos together" {
  run bin/splice -f $OUTPUT_DIR/spliced.mp4 tests/test_silence_video.mp4 tests/test_silence_video.mp4
  [ "$status" -eq 0 ]

  run stat -f%z $OUTPUT_DIR/spliced.mp4
  [ "$output" -gt 0 ]

  # Check that output file has the correct duration
  run ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $OUTPUT_DIR/spliced.mp4
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^120\.0[0-9]*$ ]]
}

# Add more specific tests here based on the functionality of splice
