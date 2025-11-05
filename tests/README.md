# Agent OS Tests

This directory contains the test suite for Agent OS.

## Running Tests

### Run All Tests

```bash
./tests/run-tests.sh
```

### Run Specific Test

```bash
./tests/unit/test-yaml-parsing.sh
./tests/unit/test-config-validation.sh
```

## Test Structure

```
tests/
├── run-tests.sh                # Main test runner
├── helpers/
│   └── test-helpers.sh         # Shared test utilities and assertions
├── unit/                       # Unit tests
│   ├── test-yaml-parsing.sh
│   └── test-config-validation.sh
├── integration/                # Integration tests (future)
└── fixtures/                   # Test data (future)
```

## Writing Tests

### Basic Test Template

```bash
#!/bin/bash

# Source dependencies
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

source "$PROJECT_ROOT/scripts/common-functions.sh"
source "$SCRIPT_DIR/../helpers/test-helpers.sh"

# Setup/Teardown
setup() {
    TEST_DIR=$(create_temp_dir)
}

teardown() {
    cleanup_temp_dir "$TEST_DIR"
}

# Test function
test_my_feature() {
    setup

    # Test code here
    local result=$(my_function "input")
    assert_equals "$result" "expected" "Should return expected value"

    teardown
}

# Main
main() {
    echo "========================================"
    echo "My Test Suite"
    echo "========================================"

    run_test test_my_feature

    test_suite_summary
}

main
```

### Available Assertions

- `assert_equals actual expected [message]`
- `assert_not_equals actual notexpected [message]`
- `assert_true condition [message]`
- `assert_false condition [message]`
- `assert_file_exists file [message]`
- `assert_file_not_exists file [message]`
- `assert_dir_exists dir [message]`
- `assert_contains haystack needle [message]`
- `assert_not_contains haystack needle [message]`

### Helper Functions

- `create_temp_dir` - Create temporary test directory
- `cleanup_temp_dir dir` - Clean up test directory
- `create_test_yaml file key1 val1 key2 val2 ...` - Create test YAML file
- `mock_command cmd output` - Mock command output
- `unmock_command cmd` - Remove mock

## Test Coverage

Current coverage:

- ✅ YAML parsing functions
- ✅ Configuration validation
- ⏳ Template compilation (TODO)
- ⏳ File operations (TODO)
- ⏳ Installation flows (TODO)
- ⏳ Update flows (TODO)

## CI Integration

Tests run automatically on:
- Pull requests
- Pushes to main branch
- Weekly schedule

See `.github/workflows/test.yml` for CI configuration.

## Contributing

When adding new features:

1. Write tests first (TDD)
2. Ensure tests pass locally
3. Add integration tests for user-facing features
4. Update this README with new test coverage

## Future Improvements

- [ ] Integration tests for full installation
- [ ] Integration tests for updates
- [ ] Template compilation tests
- [ ] Profile creation tests
- [ ] Fixture library for test data
- [ ] Code coverage reporting
- [ ] Performance benchmarks
