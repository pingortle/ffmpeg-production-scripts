#!/usr/bin/env bats

@test "splice exists and is executable" {
  run command -v bin/splice
  [ "$status" -eq 0 ]
  [ -x "$(command -v bin/splice)" ]
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

# Add more specific tests here based on the functionality of splice
