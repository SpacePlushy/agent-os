#!/bin/bash

# =============================================================================
# Unit Tests for YAML Parsing
# Tests the YAML parsing functions in common-functions.sh
# =============================================================================

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

# Source dependencies
source "$PROJECT_ROOT/scripts/common-functions.sh"
source "$SCRIPT_DIR/../helpers/test-helpers.sh"

# -----------------------------------------------------------------------------
# Setup/Teardown
# -----------------------------------------------------------------------------

setup() {
    TEST_DIR=$(create_temp_dir)
    TEST_YAML="$TEST_DIR/test.yml"
}

teardown() {
    cleanup_temp_dir "$TEST_DIR"
}

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

test_get_yaml_value_simple() {
    setup

    create_test_yaml "$TEST_YAML" "version" "2.1.1" "profile" "default"

    local version=$(get_yaml_value "$TEST_YAML" "version" "")
    assert_equals "$version" "2.1.1" "Should parse version"

    local profile=$(get_yaml_value "$TEST_YAML" "profile" "")
    assert_equals "$profile" "default" "Should parse profile"

    teardown
}

test_get_yaml_value_boolean() {
    setup

    create_test_yaml "$TEST_YAML" "claude_code_commands" "true" "agent_os_commands" "false"

    local ccc=$(get_yaml_value "$TEST_YAML" "claude_code_commands" "")
    assert_equals "$ccc" "true" "Should parse true boolean"

    local aoc=$(get_yaml_value "$TEST_YAML" "agent_os_commands" "")
    assert_equals "$aoc" "false" "Should parse false boolean"

    teardown
}

test_get_yaml_value_default() {
    setup

    create_test_yaml "$TEST_YAML" "version" "2.1.1"

    local missing=$(get_yaml_value "$TEST_YAML" "nonexistent" "default_value")
    assert_equals "$missing" "default_value" "Should return default for missing key"

    teardown
}

test_get_yaml_value_with_spaces() {
    setup

    cat > "$TEST_YAML" <<EOF
version:    2.1.1
profile:  default
name: test project
EOF

    local version=$(get_yaml_value "$TEST_YAML" "version" "")
    assert_equals "$version" "2.1.1" "Should handle extra spaces after colon"

    local profile=$(get_yaml_value "$TEST_YAML" "profile" "")
    assert_equals "$profile" "default" "Should trim trailing spaces"

    local name=$(get_yaml_value "$TEST_YAML" "name" "")
    assert_equals "$name" "test project" "Should preserve spaces in value"

    teardown
}

test_get_yaml_value_with_comments() {
    setup

    cat > "$TEST_YAML" <<EOF
# This is a comment
version: 2.1.1
# Another comment
profile: default
EOF

    local version=$(get_yaml_value "$TEST_YAML" "version" "")
    assert_equals "$version" "2.1.1" "Should ignore comment lines"

    teardown
}

test_get_yaml_value_missing_file() {
    setup

    local result=$(get_yaml_value "/nonexistent/file.yml" "version" "fallback")
    assert_equals "$result" "fallback" "Should return default for missing file"

    teardown
}

# -----------------------------------------------------------------------------
# Run Tests
# -----------------------------------------------------------------------------

main() {
    echo "========================================"
    echo "YAML Parsing Tests"
    echo "========================================"

    run_test test_get_yaml_value_simple
    run_test test_get_yaml_value_boolean
    run_test test_get_yaml_value_default
    run_test test_get_yaml_value_with_spaces
    run_test test_get_yaml_value_with_comments
    run_test test_get_yaml_value_missing_file

    test_suite_summary
}

main
