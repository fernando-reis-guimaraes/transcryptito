#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/_test_helper.bash"

# Custom setup: don't init transcrypt
# We need to init and tear down Git repo for these tests, mainly to avoid
# falling back to the transcrypt repo's Git config and partial transcrypt setup
# shellcheck disable=SC2034
SETUP_SKIP_INIT_TRANSCRYPT=1


# Operations that should work in a repo not yet initialised

@test "not inited: show help for --help" {
  run ../transcryptito --help
  [ "${lines[1]}" = "     transcryptito -- transparently encrypt files within a git repository" ]
}

@test "not inited: show help for -h" {
  run ../transcryptito -h
  [ "${lines[1]}" = "     transcryptito -- transparently encrypt files within a git repository" ]
}

@test "not inited: show version for --version" {
  VERSION=$(../transcryptito -v | awk '{print $2}')
  run ../transcryptito --version
  [ "${lines[0]}" = "transcryptito $VERSION" ]
}

@test "not inited: show version for -v" {
  VERSION=$(../transcryptito -v | awk '{print $2}')
  run ../transcryptito -v
  [ "${lines[0]}" = "transcryptito $VERSION" ]
}

@test "not inited: no files listed for --list" {
  run ../transcryptito --list
  if [[ "${output}" = *"WARNING"* ]]; then
    [ "${lines[0]}" = "*** WARNING : deprecated key derivation used." ]
    [ "${lines[1]}" = "Using -iter or -pbkdf2 would be better." ]
  else
    [ "${lines[0]}" = "" ]
  fi
}

@test "not inited: no files listed for -l" {
  run ../transcryptito -l
  if [[ "${output}" = *"WARNING"* ]]; then
    [ "${lines[0]}" = "*** WARNING : deprecated key derivation used." ]
    [ "${lines[1]}" = "Using -iter or -pbkdf2 would be better." ]
  else
    [ "${lines[0]}" = "" ]
  fi
}


# Operations that should not work in a repo not yet initialised

@test "not inited: error on --display" {
  run ../transcryptito --display
  [ "$status" -ne 0 ]
  [[ "${output}" = *"transcryptito: the current repository is not configured"* ]]
}

@test "not inited: error on -d" {
  run ../transcryptito -d
  [ "$status" -ne 0 ]
  [[ "${output}" = *"transcryptito: the current repository is not configured"* ]]
}

@test "not inited: error on --uninstall" {
  run ../transcryptito --uninstall
  [ "$status" -ne 0 ]
  [[ "${output}" = *"transcryptito: the current repository is not configured"* ]]
}

@test "not inited: error on -u" {
  run ../transcryptito -u
  [ "$status" -ne 0 ]
  [[ "${output}" = *"transcryptito: the current repository is not configured"* ]]
}


@test "not inited: error on --upgrade" {
  run ../transcryptito --upgrade
  [ "$status" -ne 0 ]
  [[ "${output}" = *"transcryptito: the current repository is not configured"* ]]
}
