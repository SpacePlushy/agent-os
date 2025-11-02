## Python best practices

### Code Style & Formatting

- **PEP 8 Compliance**: Follow PEP 8 style guide; enforce automatically with `black` and `ruff`
- **Line Length**: 88 characters (black default) or 100 for complex projects; consistency matters
- **Imports Organization**: Standard library ’ third-party ’ local; alphabetize within groups; use `isort` or `ruff`
- **One Import Per Line**: Import modules on separate lines for clarity (except `from` imports)
- **Avoid Wildcard Imports**: Never use `from module import *`; be explicit about imported names
- **String Quotes**: Be consistent; prefer double quotes `"` or single quotes `'` project-wide

### Type Hints & Type Safety

- **Always Use Type Hints**: Annotate all function signatures with parameter and return types
- **Modern Syntax**: Use Python 3.10+ syntax (`list[int]`, `dict[str, Any]`) instead of `typing.List`, `typing.Dict`
- **Optional Types**: Use `| None` (Python 3.10+) instead of `Optional[T]`
- **Type Checking**: Run `mypy` in strict mode; fix all type errors before deployment
- **Generic Types**: Use TypeVar and Generic for reusable type-safe functions and classes
- **Protocol for Duck Typing**: Use `Protocol` for structural subtyping instead of informal interfaces
- **Literal Types**: Use `Literal` for string/int enums when appropriate
- **TypedDict**: Use `TypedDict` for dictionary structures with known keys

### Modern Python Features

- **F-strings**: Always use f-strings for string interpolation (Python 3.6+)
- **Dataclasses**: Use `@dataclass` for simple data containers instead of manual `__init__`
- **Pathlib**: Use `pathlib.Path` for all file path operations; avoid `os.path`
- **Context Managers**: Use `with` statements for resource management (files, locks, connections)
- **List/Dict/Set Comprehensions**: Prefer comprehensions for simple transformations
- **Walrus Operator**: Use `:=` to reduce code duplication when appropriate (Python 3.8+)
- **Match Statements**: Use structural pattern matching for complex conditionals (Python 3.10+)
- **Enum Classes**: Use `enum.Enum` or `enum.StrEnum` for sets of constants

### Functions & Methods

- **Small Functions**: Keep functions under 30 lines; each should do one thing well
- **Function Names**: Use verb_noun pattern (snake_case): `get_user_data`, `calculate_total`, `validate_email`
- **Default Arguments**: Avoid mutable defaults (`[]`, `{}`); use `None` and create inside function
- **Keyword Arguments**: Use keyword-only arguments (`*,` separator) for functions with many parameters
- **Return Early**: Validate and return early; avoid deep nesting
- **Pure Functions**: Prefer pure functions without side effects when possible
- **Docstrings**: Use NumPy or Google style docstrings for all public functions and classes

### Object-Oriented Programming

- **Composition Over Inheritance**: Favor composition; use inheritance sparingly
- **Dataclasses for Data**: Use `@dataclass` for simple data structures; Pydantic for validation
- **Private Attributes**: Use single underscore `_attr` for internal use; double `__attr` for name mangling (rare)
- **Properties**: Use `@property` decorator for computed attributes and controlled access
- **Class Methods**: Use `@classmethod` for alternative constructors; `@staticmethod` for namespace grouping
- **Abstract Base Classes**: Use `abc.ABC` and `@abstractmethod` for interfaces
- **Slots**: Use `__slots__` to reduce memory for classes with many instances

### Error Handling

- **Specific Exceptions**: Catch specific exceptions; avoid bare `except:`
- **Custom Exceptions**: Define custom exception classes for domain-specific errors
- **Exception Chaining**: Use `raise ... from e` to preserve exception context
- **EAFP Style**: "Easier to Ask for Forgiveness than Permission" - use try/except over if checks
- **Context Managers for Cleanup**: Use context managers or `finally` blocks to ensure cleanup
- **Logging Exceptions**: Log exceptions with `logger.exception()` to include traceback
- **Fail Fast**: Validate inputs early; raise exceptions for invalid states

### Testing

- **Pytest Framework**: Use pytest for all testing; leverage fixtures and parametrize
- **Test Organization**: Mirror source structure; name tests `test_*.py` with `test_*` functions
- **Fixtures**: Use pytest fixtures for setup/teardown; scope appropriately (function, class, module, session)
- **Parametrize**: Use `@pytest.mark.parametrize` for testing multiple scenarios
- **Mocking**: Use `unittest.mock` or `pytest-mock` for isolating units under test
- **Coverage**: Aim for 80%+ coverage; use `pytest-cov` for reporting
- **Property Testing**: Use `hypothesis` for property-based testing of complex logic

### Dependencies & Virtual Environments

- **Virtual Environments**: Always use virtual environments (`venv`, `conda`, or `poetry`)
- **Requirements Files**: Use `requirements.txt` for simple projects; `pyproject.toml` + Poetry for complex ones
- **Pin Versions**: Pin direct dependencies; use lock files for reproducibility
- **Separate Dev Dependencies**: Keep dev dependencies separate from production
- **Minimal Dependencies**: Only add dependencies when necessary; prefer standard library

### Performance & Optimization

- **Profile Before Optimizing**: Use `cProfile` or `line_profiler` to find bottlenecks
- **Generators**: Use generators for lazy evaluation of large datasets
- **List Comprehensions**: Faster than loops for simple transformations
- **Built-in Functions**: Use built-ins (`map`, `filter`, `sum`, `any`, `all`) - they're optimized in C
- **NumPy for Numerical**: Use NumPy arrays instead of lists for numerical computations
- **Avoid Premature Optimization**: Write clean code first; optimize hot paths only

### Data Structures

- **Choose Right Structure**: List for ordered collections, Set for uniqueness, Dict for key-value, Tuple for immutability
- **Collections Module**: Use `collections.defaultdict`, `Counter`, `deque`, `namedtuple` when appropriate
- **Dataclasses**: Use for structured data with type hints
- **Frozen Dataclasses**: Use `frozen=True` for immutable data structures
- **Sets for Membership**: Use sets for O(1) membership testing instead of lists

### File I/O

- **Context Managers**: Always use `with open()` for file operations
- **Pathlib**: Use `Path.read_text()`, `Path.write_text()` for simple file operations
- **Binary vs Text**: Explicitly specify `'rb'`/`'wb'` vs `'r'`/`'w'`; set encoding for text files
- **JSON**: Use `json.dumps()`/`json.loads()`; consider `orjson` for performance
- **CSV**: Use `csv.DictReader` and `csv.DictWriter` for structured CSV operations

### Logging

- **Use Logging Module**: Never use `print()` for production logging
- **Structured Logging**: Include context in log messages; use `structlog` for structured logs
- **Log Levels**: DEBUG (development), INFO (routine events), WARNING (concerns), ERROR (failures), CRITICAL (system issues)
- **Logger per Module**: Get logger with `logger = logging.getLogger(__name__)`
- **Configuration**: Configure logging once at application entry point
- **Exception Logging**: Use `logger.exception()` in except blocks for automatic traceback

### Security Best Practices

- **Input Validation**: Validate and sanitize all user inputs
- **SQL Injection**: Use parameterized queries or ORM; never concatenate SQL strings
- **Secrets Management**: Use environment variables or secret management services; never hardcode secrets
- **Cryptography**: Use `cryptography` library; avoid `pycrypto` (deprecated)
- **Dependency Scanning**: Use `safety` or `pip-audit` to check for known vulnerabilities

### Anti-Patterns to Avoid

- **Global Variables**: Minimize global state; pass dependencies explicitly
- **Circular Imports**: Refactor code structure to eliminate circular dependencies
- **Mutable Default Arguments**: Never use `def func(arg=[]):`
- **Bare Except**: Never catch all exceptions silently
- **String Concatenation in Loops**: Use `''.join(list)` or f-strings
- **Ignoring Context Managers**: Always use `with` for file/network/database operations
- **Not Using Enumerate**: Use `enumerate()` instead of manual counter in loops
- **Checking for Empty**: Use `if not my_list:` instead of `if len(my_list) == 0:`
