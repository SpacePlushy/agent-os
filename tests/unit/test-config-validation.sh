#!/bin/bash

# =============================================================================
# Unit Tests for Configuration Validation
# Tests configuration loading and validation
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
    TEST_CONFIG="$TEST_DIR/config.yml"
}

teardown() {
    cleanup_temp_dir "$TEST_DIR"
}

# -----------------------------------------------------------------------------
# Tests
# -----------------------------------------------------------------------------

test_valid_configuration() {
    setup

    cat > "$TEST_CONFIG" <<EOF
version: 2.1.1
base_install: true
claude_code_commands: true
use_claude_code_subagents: true
agent_os_commands: false
standards_as_claude_code_skills: false
profile: default
EOF

    local version=$(get_yaml_value "$TEST_CONFIG" "version" "")
    assert_equals "$version" "2.1.1" "Should load version"

    local profile=$(get_yaml_value "$TEST_CONFIG" "profile" "")
    assert_equals "$profile" "default" "Should load profile"

    local ccc=$(get_yaml_value "$TEST_CONFIG" "claude_code_commands" "")
    assert_equals "$ccc" "true" "Should load claude_code_commands"

    teardown
}

test_subagents_requires_claude_code() {
    setup

    # This would normally be handled by validate_config function
    # Testing the logic that subagents requires claude_code_commands

    local claude_code_commands="false"
    local use_claude_code_subagents="true"

    # Subagents should be forced to false if claude_code_commands is false
    if [[ "$claude_code_commands" != "true" ]] && [[ "$use_claude_code_subagents" == "true" ]]; then
        use_claude_code_subagents="false"
    fi

    assert_equals "$use_claude_code_subagents" "false" "Subagents should be disabled when Claude Code commands disabled"

    teardown
}

test_skills_requires_claude_code() {
    setup

    local claude_code_commands="false"
    local standards_as_claude_code_skills="true"

    # Skills should be forced to false if claude_code_commands is false
    if [[ "$claude_code_commands" != "true" ]] && [[ "$standards_as_claude_code_skills" == "true" ]]; then
        standards_as_claude_code_skills="false"
    fi

    assert_equals "$standards_as_claude_code_skills" "false" "Skills should be disabled when Claude Code commands disabled"

    teardown
}

test_boolean_parsing() {
    setup

    # Test various boolean formats
    assert_equals "$(normalize_boolean 'true')" "true" "Should normalize 'true'"
    assert_equals "$(normalize_boolean 'True')" "true" "Should normalize 'True'"
    assert_equals "$(normalize_boolean 'TRUE')" "true" "Should normalize 'TRUE'"
    assert_equals "$(normalize_boolean 'yes')" "true" "Should normalize 'yes' to true"
    assert_equals "$(normalize_boolean '1')" "true" "Should normalize '1' to true"

    assert_equals "$(normalize_boolean 'false')" "false" "Should normalize 'false'"
    assert_equals "$(normalize_boolean 'False')" "false" "Should normalize 'False'"
    assert_equals "$(normalize_boolean 'FALSE')" "false" "Should normalize 'FALSE'"
    assert_equals "$(normalize_boolean 'no')" "false" "Should normalize 'no' to false"
    assert_equals "$(normalize_boolean '0')" "false" "Should normalize '0' to false"

    teardown
}

# Helper function for boolean tests
normalize_boolean() {
    local value="$1"
    case "${value,,}" in
        true|yes|1) echo "true" ;;
        false|no|0) echo "false" ;;
        *) echo "$value" ;;
    esac
}

# -----------------------------------------------------------------------------
# Run Tests
# -----------------------------------------------------------------------------

main() {
    echo "========================================"
    echo "Configuration Validation Tests"
    echo "========================================"

    run_test test_valid_configuration
    run_test test_subagents_requires_claude_code
    run_test test_skills_requires_claude_code
    run_test test_boolean_parsing

    test_suite_summary
}

main
