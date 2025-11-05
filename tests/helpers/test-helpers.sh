#!/bin/bash

# =============================================================================
# Test Helpers for Agent OS
# Shared utilities for testing
# =============================================================================

# Colors for test output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# -----------------------------------------------------------------------------
# Assertion Functions
# -----------------------------------------------------------------------------

assert_equals() {
    local actual="$1"
    local expected="$2"
    local message="${3:-Assertion failed}"

    ((TESTS_RUN++))

    if [[ "$actual" == "$expected" ]]; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Expected: $expected"
        echo "  Got:      $actual"
        return 1
    fi
}

assert_not_equals() {
    local actual="$1"
    local expected="$2"
    local message="${3:-Assertion failed}"

    ((TESTS_RUN++))

    if [[ "$actual" != "$expected" ]]; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Expected not to be: $expected"
        echo "  Got:                $actual"
        return 1
    fi
}

assert_true() {
    local condition="$1"
    local message="${2:-Assertion failed}"

    ((TESTS_RUN++))

    if eval "$condition"; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Condition failed: $condition"
        return 1
    fi
}

assert_false() {
    local condition="$1"
    local message="${2:-Assertion failed}"

    ((TESTS_RUN++))

    if ! eval "$condition"; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Condition should have failed: $condition"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist: $file}"

    assert_true "[[ -f '$file' ]]" "$message"
}

assert_file_not_exists() {
    local file="$1"
    local message="${2:-File should not exist: $file}"

    assert_false "[[ -f '$file' ]]" "$message"
}

assert_dir_exists() {
    local dir="$1"
    local message="${2:-Directory should exist: $dir}"

    assert_true "[[ -d '$dir' ]]" "$message"
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String should contain substring}"

    ((TESTS_RUN++))

    if [[ "$haystack" == *"$needle"* ]]; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Haystack: $haystack"
        echo "  Needle:   $needle"
        return 1
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String should not contain substring}"

    ((TESTS_RUN++))

    if [[ "$haystack" != *"$needle"* ]]; then
        ((TESTS_PASSED++))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        ((TESTS_FAILED++))
        echo -e "${RED}✗${NC} $message"
        echo "  Haystack: $haystack"
        echo "  Needle:   $needle"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Test Runner Functions
# -----------------------------------------------------------------------------

run_test() {
    local test_name="$1"

    echo ""
    echo "Running: $test_name"
    echo "----------------------------------------"

    # Run the test function
    "$test_name"

    echo "----------------------------------------"
}

test_suite_summary() {
    echo ""
    echo "========================================"
    echo "Test Suite Summary"
    echo "========================================"
    echo "Tests run:    $TESTS_RUN"
    echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"

    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"
        echo ""
        echo "FAILED"
        return 1
    else
        echo "Tests failed: 0"
        echo ""
        echo -e "${GREEN}SUCCESS${NC}"
        return 0
    fi
}

# -----------------------------------------------------------------------------
# Fixture Functions
# -----------------------------------------------------------------------------

create_temp_dir() {
    mktemp -d -t agent-os-test-XXXXXX
}

cleanup_temp_dir() {
    local dir="$1"
    if [[ -n "$dir" ]] && [[ "$dir" == *"agent-os-test"* ]]; then
        rm -rf "$dir"
    fi
}

create_test_yaml() {
    local file="$1"
    shift

    # Create YAML file with key-value pairs
    # Usage: create_test_yaml "/tmp/test.yml" "version" "2.1.1" "profile" "default"

    > "$file"

    while [[ $# -gt 0 ]]; do
        local key="$1"
        local value="$2"
        echo "$key: $value" >> "$file"
        shift 2
    done
}

# -----------------------------------------------------------------------------
# Mock Functions
# -----------------------------------------------------------------------------

mock_command() {
    local cmd="$1"
    local output="$2"

    # Create a function that overrides the command
    eval "$cmd() { echo '$output'; }"
}

unmock_command() {
    local cmd="$1"
    unset -f "$cmd"
}
