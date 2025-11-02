## Testing and verification during development

### Core Testing Philosophy

- **Test As You Build**: Write and run tests continuously during development, not just at the end
- **Verify Each Step**: After implementing each feature or function, verify it works before moving to the next step
- **Incremental Validation**: Test incrementally as you add functionality; catch issues early when they're easier to fix
- **Build Confidence**: Each passing test builds confidence that your implementation is correct
- **Fast Feedback Loop**: Run relevant tests after each change to get immediate feedback

### Test-Driven Development (TDD) Approach

- **Red-Green-Refactor**: Write failing test → Make it pass → Refactor for quality
- **Test First (When Appropriate)**: For well-defined requirements, write test before implementation
- **Clarifies Requirements**: Writing tests first forces you to think through expected behavior
- **Design Aid**: Tests reveal design issues early; hard-to-test code often indicates design problems
- **Living Documentation**: Tests serve as executable documentation of how code should behave

### Testing During Development Workflow

1. **Implement a feature/function**
2. **Write test(s) for that feature**
3. **Run the tests to verify it works**
4. **Fix any issues found**
5. **Run tests again to confirm fix**
6. **Move to next feature**

### What to Test During Development

- **Core Functionality**: Test primary user flows and critical business logic as you build them
- **Edge Cases**: Test boundary conditions and edge cases for critical code paths
- **Error Handling**: Verify error handling works correctly; test failure scenarios
- **Integration Points**: Test that components integrate correctly with dependencies
- **Validation Logic**: Verify input validation catches invalid data
- **Business Rules**: Test that business rules are correctly enforced

### Types of Tests to Write

#### Unit Tests
- **Granular Testing**: Test individual functions and methods in isolation
- **Fast Execution**: Unit tests should run in milliseconds; run them frequently
- **Mock Dependencies**: Isolate units by mocking databases, APIs, file systems, and external services
- **Test Behavior**: Focus on what the code does (outputs, side effects) not how it does it
- **Clear Names**: Use descriptive test names that explain what's being tested and expected outcome
  - Good: `test_user_creation_fails_with_invalid_email`
  - Bad: `test_user_1`

#### Integration Tests
- **Component Interaction**: Test that multiple components work together correctly
- **Real Dependencies**: Use real databases, APIs when possible; test actual integration
- **Data Flow**: Verify data flows correctly through multiple layers
- **End-to-End Scenarios**: Test realistic user scenarios from start to finish

#### Functional Tests
- **Feature Verification**: Test that features work from user perspective
- **User Flows**: Verify complete user workflows (login → action → result)
- **Browser Testing**: For web apps, test in actual browsers (Playwright, Cypress)
- **API Testing**: Test API endpoints with real HTTP requests

### Verification Checkpoints

#### After Each Function/Method
- [ ] Function returns expected output for valid inputs
- [ ] Function handles invalid inputs gracefully
- [ ] Edge cases are covered (empty, null, boundary values)
- [ ] Error cases throw appropriate exceptions

#### After Each Feature
- [ ] Feature works for primary use case
- [ ] Feature handles errors appropriately
- [ ] Feature integrates with existing code
- [ ] Existing tests still pass (no regressions)

#### After Each Task/Story
- [ ] All acceptance criteria are met
- [ ] All tests pass (unit, integration, functional)
- [ ] Code has been tested manually (when applicable)
- [ ] No known bugs or issues remain
- [ ] Performance is acceptable

#### Before Committing Code
- [ ] Run full test suite and verify all tests pass
- [ ] Run linter and fix any issues
- [ ] Test locally in development environment
- [ ] Review changes and ensure quality

### Test Organization

- **Parallel Structure**: Mirror source code structure in test directory
```
src/
  users/
    service.ts
    controller.ts
tests/
  users/
    service.test.ts
    controller.test.ts
```

- **Naming Convention**: Name test files `*.test.ts`, `*.spec.ts`, or `test_*.py`
- **Group Related Tests**: Use `describe`/`context` blocks to group related tests
- **Setup/Teardown**: Use fixtures, beforeEach, afterEach for common setup

### Running Tests During Development

#### Web Development (JavaScript/TypeScript)
```bash
# Run tests in watch mode - reruns on file changes
npm test -- --watch

# Run specific test file
npm test -- path/to/file.test.ts

# Run tests matching pattern
npm test -- --testNamePattern="user creation"
```

#### Python Development
```bash
# Run all tests
pytest

# Run in watch mode (with pytest-watch)
ptw

# Run specific test file
pytest tests/test_users.py

# Run specific test
pytest tests/test_users.py::test_create_user
```

#### Embedded/Firmware
```bash
# Run unit tests in native environment
pio test -e native

# Run specific test
pio test -e native --filter test_sensor_reading
```

### Continuous Testing Practices

- **Watch Mode**: Run tests in watch mode during development for instant feedback
- **Pre-Commit Hooks**: Run tests automatically before committing code
- **Fast Tests First**: Run fast unit tests first, slower integration tests after
- **Selective Testing**: Run only tests related to changed code during development
- **Full Suite Periodically**: Run full test suite periodically to catch integration issues

### Manual Verification

- **Visual Inspection**: For UI changes, visually verify appearance and behavior
- **User Flow Testing**: Manually test critical user flows in development environment
- **Cross-Browser Testing**: Test in multiple browsers for web applications
- **Device Testing**: Test on actual hardware for embedded/mobile applications
- **Performance Testing**: Check performance for critical operations

### Test Coverage

- **Aim for High Coverage**: Target 80%+ code coverage for critical business logic
- **Coverage Tools**: Use coverage tools to identify untested code
  - JavaScript: `jest --coverage`
  - Python: `pytest --cov=src`
- **Quality Over Quantity**: 100% coverage doesn't guarantee correctness; focus on meaningful tests
- **Don't Test Framework Code**: Don't write tests for third-party library code
- **Test Critical Paths**: Ensure critical user paths have thorough test coverage

### Debugging Failed Tests

- **Read Error Messages**: Carefully read test failure messages; they usually indicate the problem
- **Isolate the Test**: Run failing test in isolation to eliminate interference
- **Add Debug Output**: Add console.log/print statements to understand what's happening
- **Use Debugger**: Step through test with debugger to find exact failure point
- **Check Assumptions**: Verify your assumptions about how code should behave
- **Simplify**: Create minimal reproduction case to isolate problem

### Test Data Management

- **Fixtures**: Use fixtures for common test data; keep tests DRY
- **Factories**: Use factory functions to create test objects with sensible defaults
- **Seed Data**: For integration tests, use consistent seed data
- **Clean State**: Ensure each test starts with clean state; reset between tests
- **Realistic Data**: Use realistic test data that resembles production data

### Performance Testing During Development

- **Benchmark Critical Operations**: Measure performance of critical operations
- **Set Performance Budgets**: Define acceptable performance thresholds
- **Profile Slow Code**: Use profilers to identify performance bottlenecks
- **Load Testing**: For APIs, test with realistic load during development
- **Memory Profiling**: Check for memory leaks in long-running operations

### Documentation in Tests

- **Self-Documenting Tests**: Tests should clearly show how code is intended to be used
- **Comment Complex Setups**: Explain non-obvious test setup or data
- **Example Usage**: Tests serve as examples for other developers
- **Document Edge Cases**: Explain why edge case tests exist

### Common Testing Patterns

#### Arrange-Act-Assert (AAA)
```typescript
test('user creation with valid data', () => {
  // Arrange: Set up test data and dependencies
  const userData = { name: 'John', email: 'john@example.com' }

  // Act: Execute the function being tested
  const user = createUser(userData)

  // Assert: Verify the results
  expect(user.name).toBe('John')
  expect(user.email).toBe('john@example.com')
  expect(user.id).toBeDefined()
})
```

#### Given-When-Then (BDD Style)
```python
def test_user_creation_with_valid_data():
    # Given: A user with valid data
    user_data = {"name": "John", "email": "john@example.com"}

    # When: We create the user
    user = create_user(user_data)

    # Then: The user should be created successfully
    assert user.name == "John"
    assert user.email == "john@example.com"
    assert user.id is not None
```

### Testing Best Practices

- **One Concept Per Test**: Each test should verify one specific behavior
- **Independent Tests**: Tests should not depend on each other; run in any order
- **Repeatable**: Tests should produce same results every time
- **Deterministic**: Avoid randomness; use fixed seeds if needed
- **Fast**: Keep tests fast; mock slow operations (database, network, file I/O)
- **Maintainable**: Write tests that are easy to understand and maintain
- **Valuable**: Write tests that catch real bugs; avoid testing trivial code

### When Tests Fail

- **Don't Ignore**: Never ignore failing tests; fix them immediately
- **Understand Why**: Understand why test failed before "fixing" it
- **Fix Root Cause**: Fix the underlying issue, not just make test pass
- **Add Test for Bug**: When you find a bug, write test that exposes it first
- **Regression Prevention**: Tests prevent bugs from coming back

### Verification Checklist (End of Development Session)

- [ ] All new code has corresponding tests
- [ ] All tests pass locally
- [ ] Manual testing completed for visual/UI changes
- [ ] No degradation in test coverage
- [ ] Code linted and formatted
- [ ] No console errors or warnings
- [ ] Performance is acceptable
- [ ] Ready to commit and push

This continuous testing and verification approach ensures quality throughout development, not just at the end.
