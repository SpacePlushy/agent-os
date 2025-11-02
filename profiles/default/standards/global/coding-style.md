## Coding style best practices

### Universal Principles (All Languages)

- **Consistent Naming Conventions**: Follow language-specific conventions (camelCase for TypeScript/JavaScript, snake_case for Python, PascalCase for classes)
- **Automated Formatting**: Use language-specific formatters (Prettier for TS/JS, black for Python, clang-format for C/C++) and enforce via pre-commit hooks
- **Meaningful Names**: Choose descriptive names that reveal intent; avoid abbreviations except industry-standard ones (e.g., `http`, `url`, `id`)
- **Small, Focused Functions**: Keep functions under 50 lines; each should do one thing well
- **Consistent Indentation**: 2 spaces for TS/JS/JSON, 4 spaces for Python, project-defined for C/C++
- **Remove Dead Code**: Delete unused code, commented blocks, and imports; rely on version control for history
- **DRY Principle**: Extract common logic into reusable functions or modules; three instances = refactor time
- **Backward compatibility only when required**: Unless specified, assume no backward compatibility is needed

### TypeScript/JavaScript (Next.js/React)

- **Type Safety**: Use TypeScript strict mode; avoid `any` types; prefer `unknown` when type is truly unknown
- **Function Naming**: Use verb-noun pattern (`getUserData`, `validateEmail`, `handleSubmit`)
- **Component Naming**: PascalCase for components; descriptive and specific (`UserProfileCard` not `Card`)
- **File Naming**: kebab-case for files (`user-profile.tsx`), match component name for single-component files
- **Const over Let**: Prefer `const` by default; use `let` only when reassignment is necessary; avoid `var`
- **Arrow Functions**: Use arrow functions for callbacks and short functions; use function declarations for top-level functions
- **Destructuring**: Destructure objects and arrays for cleaner code
- **Template Literals**: Use template literals over string concatenation
- **Optional Chaining**: Use `?.` for safe property access on potentially undefined objects
- **Nullish Coalescing**: Use `??` instead of `||` when you specifically want to check for `null`/`undefined`

### Python

- **PEP 8 Compliance**: Follow PEP 8 style guide; enforce with `black` and `ruff`
- **Type Hints**: Use type hints for all function signatures; leverage Python 3.10+ syntax (`list[int]` not `List[int]`)
- **F-strings**: Use f-strings for string formatting (not `.format()` or `%`)
- **List/Dict Comprehensions**: Use comprehensions for simple transformations; avoid complex nested comprehensions
- **Context Managers**: Use `with` statements for resource management (files, connections, locks)
- **Pathlib**: Use `pathlib.Path` instead of `os.path` for file path operations
- **Dataclasses/Pydantic**: Use dataclasses or Pydantic models instead of dictionaries for structured data
- **Async/Await**: Use `async`/`await` for I/O-bound operations; avoid blocking calls in async functions
- **Naming**: Functions and variables in snake_case, classes in PascalCase, constants in UPPER_SNAKE_CASE

### C/C++ (Embedded Systems)

- **Naming Convention**: snake_case for functions and variables, PascalCase for types/structs, UPPER_SNAKE_CASE for macros
- **Const Correctness**: Use `const` for function parameters and return values when applicable
- **Pointer Safety**: Initialize pointers to `NULL`; check for `NULL` before dereferencing
- **Static Functions**: Use `static` for functions that don't need external linkage
- **Avoid Global Variables**: Minimize global state; use singleton patterns or dependency injection
- **RAII in C++**: Use constructors/destructors for resource management; leverage smart pointers (`unique_ptr`, `shared_ptr`)
- **Minimize Dynamic Allocation**: Prefer stack allocation or static buffers for embedded systems; document heap usage
- **Magic Numbers**: Define constants or enums instead of magic numbers in code
- **Header Guards**: Use `#ifndef`/`#define` or `#pragma once` for header guards
- **Function Length**: Especially critical in embedded; keep ISRs (interrupt service routines) minimal

### Code Organization

- **File Structure**: Group related functionality; one primary class/component per file
- **Import Order**: Standard library, third-party libraries, local imports (enforce with tooling)
- **Barrel Exports**: Use index files to re-export from a module for cleaner imports (TypeScript)
- **Separation of Concerns**: Separate business logic from UI, I/O from computation, hardware from application logic
- **Configuration Over Code**: Externalize configuration to environment variables or config files
- **Single Responsibility**: Each module/file should have one clear purpose

### Linting & Formatting

- **Automated Enforcement**: Configure linters and formatters in CI/CD pipeline
- **Pre-commit Hooks**: Run formatters and linters before commits
- **TypeScript**: ESLint with `@typescript-eslint`, Prettier
- **Python**: ruff (combines flake8, isort, and more), black, mypy for type checking
- **C/C++**: clang-format, cppcheck, clang-tidy
- **Editor Config**: Use `.editorconfig` for consistent settings across team
