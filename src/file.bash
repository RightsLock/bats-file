#
# bats-file - Common filesystem assertions and helpers for Bats
#
# Written in 2016 by Zoltan Tombol <zoltan dot tombol at gmail dot com>
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.
#

#
# file.bash
# ---------
#
# Assertions are functions that perform a test and output relevant
# information on failure to help debugging. They return 1 on failure
# and 0 otherwise.
#
# All output is formatted for readability using the functions of
# `output.bash' and sent to the standard error.
#

# Fail and display path of the file (or directory) if it does not exist.
# This function is the logical complement of `assert_file_not_exist'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
# Returns:
#   0 - file exists
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_exist() {
  local -r file="$1"
  if [[ ! -e "$file" ]]; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" \
      | batslib_decorate 'file does not exist' \
      | fail
  fi
}

# Fail and display path of the file (or directory) if it exists. This
# function is the logical complement of `assert_file_exist'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
# Returns:
#   0 - file does not exist
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_not_exist() {
  local -r file="$1"
  if [[ -e "$file" ]]; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" \
      | batslib_decorate 'file exists, but it was expected to be absent' \
      | fail
  fi
}

# Fail and display path of the file (or directory) if it is not empty.
# This function is the logical complement of `assert_file_not_empty'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
# Returns:
#   0 - file empty
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_empty() {
  local -r file="$1"
  if [[ -s "$file" ]]; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    { local -ir width=8
      batslib_print_kv_single "$width" 'path' "${file/$rem/$add}"
      batslib_print_kv_single_or_multi "$width" \
          'output' "$(cat $file)"
    } | batslib_decorate 'file is not empty' \
      | fail
  fi
}

# Fail and display path of the file (or directory) if it is empty. This
# function is the logical complement of `assert_file_empty'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
# Returns:
#   0 - file is not empty
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_not_empty() {
  local -r file="$1"
  if [[ ! -s "$file" ]]; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" \
      | batslib_decorate 'file empty, but it was expected to contain something' \
      | fail
  fi
}

# Fail and display path of the file (or directory) if it does not contain a string.
# This function is the logical complement of `assert_file_not_contains'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
#   $2 - regex
# Returns:
#   0 - file contains regex
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_contains() {
  local -r file="$1"
  local -r regex="$2"
  if ! grep -q "$regex" "$file"; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" \
      | batslib_decorate 'file does not contain regex' \
      | fail
  fi
}

# Fail and display path of the file (or directory) if it does not match a size.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
#   $2 - expected size (bytes)
# Returns:
#   0 - file is correct size
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_size_equals() {
  local -r file="$1"
  local -r expectedsize="$2"
  local -r size=$( wc -c "$file" | awk '{print $1}' )
  if [ ! "$expectedsize" = "$size" ]; then
    local -r rem="$BATSLIB_FILE_PATH_REM"
    local -r add="$BATSLIB_FILE_PATH_ADD"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" \
      | batslib_decorate 'file size does not match expected size' \
      | fail
  fi
}