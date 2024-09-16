#!/usr/bin/env bats

@test "remove-silence exists and is executable" {
  run command -v bin/remove-silence
  [ "$status" -eq 0 ]
  [ -x "$(command -v bin/remove-silence)" ]
}

@test "remove-silence runs without error" {
  run bin/remove-silence
  [ "$status" -eq 0 ]
}

# Add more specific tests here based on the functionality of remove-silence
