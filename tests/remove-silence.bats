#!/usr/bin/env bats

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
  run bin/remove-silence -m remove input.mp4
  [ "$status" -eq 0 ]
  run bin/remove-silence -m fastforward input.mp4
  [ "$status" -eq 0 ]
}

@test "remove-silence rejects invalid mode options" {
  run bin/remove-silence -m invalid_mode input.mp4
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" == "Error: Invalid mode. Use 'remove' or 'fastforward'." ]]
}

# Add more specific tests here based on the functionality of remove-silence
