#!/bin/bash

# =============================================================================
# Test Runner for Agent OS
# Runs all unit and integration tests
# =============================================================================

set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

run_test_file() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .sh)

    echo ""
    echo -e "${BLUE}Running: $test_name${NC}"
    echo "----------------------------------------"

    if bash "$test_file"; then
        echo -e "${GREEN}✓ $test_name PASSED${NC}"
        return 0
    else
        echo -e "${RED}✗ $test_name FAILED${NC}"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    local failed=0
    local passed=0

    print_header "Agent OS Test Suite"

    # Check if test directory exists
    if [[ ! -d "$SCRIPT_DIR/unit" ]]; then
        echo -e "${RED}Error: Test directory not found${NC}"
        exit 1
    fi

    # Run unit tests
    print_header "Unit Tests"

    for test_file in "$SCRIPT_DIR/unit"/*.sh; do
        if [[ -f "$test_file" ]]; then
            if run_test_file "$test_file"; then
                ((passed++))
            else
                ((failed++))
            fi
        fi
    done

    # Run integration tests (if they exist)
    if [[ -d "$SCRIPT_DIR/integration" ]]; then
        print_header "Integration Tests"

        for test_file in "$SCRIPT_DIR/integration"/*.sh; do
            if [[ -f "$test_file" ]]; then
                if run_test_file "$test_file"; then
                    ((passed++))
                else
                    ((failed++))
                fi
            fi
        done
    fi

    # Summary
    print_header "Test Suite Summary"

    echo "Test files run: $((passed + failed))"
    echo -e "${GREEN}Passed: $passed${NC}"

    if [[ $failed -gt 0 ]]; then
        echo -e "${RED}Failed: $failed${NC}"
        echo ""
        echo -e "${RED}OVERALL: FAILED${NC}"
        exit 1
    else
        echo "Failed: 0"
        echo ""
        echo -e "${GREEN}OVERALL: SUCCESS${NC}"
        exit 0
    fi
}

# Check for help flag
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Run Agent OS test suite"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0             Run all tests"
    echo "  $0 unit        Run unit tests only (not yet implemented)"
    echo "  $0 integration Run integration tests only (not yet implemented)"
    exit 0
fi

main "$@"
