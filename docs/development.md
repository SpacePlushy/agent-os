# Development Guide

Guide for contributing to and extending Agent OS.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Code Structure](#code-structure)
- [Testing](#testing)
- [Making Changes](#making-changes)
- [Creating Profiles](#creating-profiles)
- [Creating Commands](#creating-commands)
- [Creating Agents](#creating-agents)
- [Contribution Guidelines](#contribution-guidelines)

---

## Getting Started

### Prerequisites

- **Bash 4.0+**: For script development
- **Git**: For version control
- **Text editor**: VS Code, vim, nano, etc.
- **Claude Code** (optional): For testing integrations
- **jq** (optional): For JSON parsing

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/agent-os.git
cd agent-os

# Add upstream remote
git remote add upstream https://github.com/buildermethods/agent-os.git

# Fetch upstream changes
git fetch upstream
```

---

## Development Setup

### Local Installation

```bash
# Don't run the normal installation
# Instead, work directly from the cloned repo

# Create symlink for easy access
ln -s $(pwd) ~/agent-os-dev

# Test scripts directly
./scripts/base-install.sh --dry-run --verbose
```

### Testing Changes

```bash
# Create a test project
mkdir ~/test-project
cd ~/test-project

# Install Agent OS from your local repo
~/agent-os-dev/scripts/project-install.sh --verbose --dry-run

# Inspect what would be installed
cat .claude/commands/agent-os/plan-product.md
```

---

## Code Structure

### Repository Layout

```
agent-os/
├── .github/                    # GitHub configurations
│   ├── workflows/              # GitHub Actions
│   ├── ISSUE_TEMPLATE/
│   ├── CONTRIBUTING.md
│   ├── CODE_OF_CONDUCT.md
│   └── SUPPORT.md
├── scripts/                    # Installation & management scripts
│   ├── base-install.sh         # Base installer (701 lines)
│   ├── project-install.sh      # Project installer (554 lines)
│   ├── project-update.sh       # Update script (922 lines)
│   ├── create-profile.sh       # Profile creator (326 lines)
│   └── common-functions.sh     # Shared utilities (1468 lines)
├── profiles/                   # Profile templates
│   └── default/
│       ├── agents/             # 8 agent definitions
│       ├── commands/           # 7 command workflows
│       ├── workflows/          # 30+ instruction files
│       └── standards/          # 15+ standard docs
├── docs/                       # Documentation
├── config.yml                  # Base configuration
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### Key Files

| File | Lines | Purpose |
|------|-------|---------|
| `common-functions.sh` | 1468 | Shared utilities (YAML parsing, file ops, compilation) |
| `project-update.sh` | 922 | Update existing project installations |
| `base-install.sh` | 701 | Install/update base system |
| `project-install.sh` | 554 | Install into projects |
| `create-profile.sh` | 326 | Create custom profiles |

---

## Testing

### Manual Testing

#### Test Base Installation

```bash
# Dry run from local repo
./scripts/base-install.sh --dry-run --verbose

# Actual installation to test directory
export BASE_DIR=~/agent-os-test
./scripts/base-install.sh

# Verify
ls -la ~/agent-os-test
```

#### Test Project Installation

```bash
# Create test project
mkdir ~/test-project
cd ~/test-project
git init

# Install from local repo
~/agent-os-dev/scripts/project-install.sh --dry-run --verbose

# Verify dry run output
# Then install for real
~/agent-os-dev/scripts/project-install.sh --verbose

# Check outputs
ls -la agent-os/
ls -la .claude/commands/agent-os/
ls -la .claude/agents/agent-os/
```

#### Test Compilation

```bash
# Check compiled command
cat .claude/commands/agent-os/plan-product.md

# Verify:
# - No {{@...}} references (should be expanded)
# - No {{IF...}} blocks (should be resolved)
# - Standards references correct
# - Workflows embedded (if single-agent)
```

### Automated Testing

Currently, Agent OS lacks automated tests. **This is a priority area for contribution!**

#### Future Test Framework (Proposal)

```bash
tests/
├── unit/
│   ├── test-yaml-parsing.sh      # Test YAML functions
│   ├── test-config-validation.sh # Test config validation
│   ├── test-compilation.sh       # Test template compilation
│   └── test-file-operations.sh   # Test file copying
├── integration/
│   ├── test-base-install.sh      # Test full base install
│   ├── test-project-install.sh   # Test project install
│   ├── test-profile-creation.sh  # Test profile creation
│   └── test-update.sh            # Test update flows
├── fixtures/
│   ├── configs/                  # Sample configs
│   ├── profiles/                 # Test profiles
│   └── projects/                 # Test projects
└── helpers/
    └── test-helpers.sh           # Shared test utilities
```

#### Example Test (Proposed)

```bash
#!/bin/bash
# tests/unit/test-yaml-parsing.sh

source ./scripts/common-functions.sh
source ./tests/helpers/test-helpers.sh

test_get_yaml_value() {
    # Create test YAML
    cat > /tmp/test.yml <<EOF
version: 2.1.1
profile: default
claude_code_commands: true
EOF

    # Test parsing
    local version=$(get_yaml_value "/tmp/test.yml" "version" "")
    assert_equals "$version" "2.1.1" "Should parse version"

    local profile=$(get_yaml_value "/tmp/test.yml" "profile" "")
    assert_equals "$profile" "default" "Should parse profile"

    # Cleanup
    rm /tmp/test.yml
}

run_test test_get_yaml_value
```

---

## Making Changes

### Branch Strategy

```bash
# Create feature branch
git checkout -b feature/my-improvement

# Or bug fix branch
git checkout -b fix/issue-description
```

### Code Style

#### Bash Scripts

**Function Documentation**:
```bash
# Brief description of function
#
# Arguments:
#   $1 - Description of first argument
#   $2 - Description of second argument
#
# Returns:
#   0 on success, 1 on failure
#
# Example:
#   my_function "value1" "value2"
my_function() {
    local arg1=$1
    local arg2=$2
    # Implementation
}
```

**Error Handling**:
```bash
# Always check command success
if ! some_command; then
    print_error "Command failed"
    return 1
fi

# Use set -e at script top
set -e
```

**Variable Naming**:
```bash
# UPPERCASE for constants
readonly BASE_DIR="$HOME/agent-os"

# lowercase for local variables
local file_count=0

# Descriptive names
local profile_name="default"  # Good
local pn="default"            # Bad
```

#### Markdown Files

**Headers**:
```markdown
# Main Title

## Section

### Subsection
```

**Code Blocks**:
````markdown
```bash
# Always specify language
command --flag value
```
````

**File References**:
```markdown
See `agent-os/standards/global/coding-style.md`
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add support for custom config paths
fix: resolve YAML parsing issue with tabs
docs: update installation guide with troubleshooting
refactor: extract YAML parsing into separate file
test: add unit tests for config validation
```

### Pull Requests

1. **Start with Discussion** (for features)
   - Open Discussion in "Ideas" category
   - Get community feedback
   - Wait for maintainer approval

2. **Create PR**:
   ```bash
   git push origin feature/my-improvement
   # Open PR on GitHub
   ```

3. **PR Description Template**:
   ```markdown
   ## Description
   Brief description of changes

   ## Motivation
   Why is this change needed?

   ## Changes
   - Change 1
   - Change 2

   ## Testing
   How was this tested?

   ## Screenshots
   (if applicable)

   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Documentation updated
   - [ ] Tests added/updated
   - [ ] Changelog updated
   ```

---

## Creating Profiles

### Profile Structure

```bash
profiles/my-profile/
├── agents/                      # Optional: custom agents
├── commands/                    # Optional: custom commands
├── workflows/                   # Optional: custom workflows
└── standards/                   # Required: standards
    ├── global/
    │   ├── coding-style.md
    │   ├── tech-stack.md
    │   └── ...
    ├── frontend/
    ├── backend/
    └── testing/
```

### Creating a Profile

```bash
# Use built-in creator
~/agent-os/scripts/create-profile.sh

# Or manually
mkdir -p ~/agent-os/profiles/my-rails-profile/{agents,commands,workflows,standards/{global,frontend,backend,testing}}

# Copy from default
cp -r ~/agent-os/profiles/default/standards/* ~/agent-os/profiles/my-rails-profile/standards/

# Customize
nano ~/agent-os/profiles/my-rails-profile/standards/global/tech-stack.md
```

### Profile Inheritance

Profiles can inherit from others:

```bash
# Start with default
cp -r ~/agent-os/profiles/default ~/agent-os/profiles/my-profile

# Override specific files
nano ~/agent-os/profiles/my-profile/standards/global/tech-stack.md

# Add custom standards
echo "# Custom Standard" > ~/agent-os/profiles/my-profile/standards/global/custom.md
```

### Testing Profiles

```bash
# Test in a project
cd ~/test-project
~/agent-os/scripts/project-install.sh --profile my-profile --dry-run

# Verify compilation
cat .claude/commands/agent-os/plan-product.md | grep -A 10 "tech-stack"
```

---

## Creating Commands

### Command Structure

Commands have two versions:

```
commands/my-command/
├── single-agent/
│   ├── my-command.md           # Entry point (single-agent)
│   ├── 1-first-phase.md        # Optional: phase files
│   └── 2-second-phase.md
└── multi-agent/
    └── my-command.md           # Entry point (multi-agent)
```

### Single-Agent Command

```markdown
---
name: my-command
description: Description of what this command does
---

# My Command

Brief description of the command purpose.

## Instructions

Step-by-step instructions for the AI agent to follow.

## Phase 1: First Step

{{@workflows/custom/first-step.md}}

## Phase 2: Second Step

{{@workflows/custom/second-step.md}}

## Standards to Apply

Apply these standards:
{{UNLESS standards_as_claude_code_skills}}
- {{agent-os/standards/global/coding-style.md}}
- {{agent-os/standards/global/tech-stack.md}}
{{ENDUNLESS standards_as_claude_code_skills}}

{{IF standards_as_claude_code_skills}}
Standards are available as Claude Code Skills. Apply relevant standards as needed.
{{ENDIF standards_as_claude_code_skills}}

## Output

Description of expected outputs.
```

### Multi-Agent Command

```markdown
---
name: my-command
description: Description (multi-agent version)
---

# My Command (Multi-Agent)

This command delegates work to specialized subagents.

## Instructions

1. Read the requirements from `requirements.md`
2. Analyze the work needed
3. Delegate to appropriate subagents:

### Frontend Work
Delegate to: frontend-implementer
Tasks: All UI and component work

### Backend Work
Delegate to: backend-implementer
Tasks: All API and business logic

## Coordination

Coordinate between subagents to ensure integration.

## Standards

Each subagent will apply relevant standards from their specialty area.
```

### Workflow Files

Referenced by commands via `{{@workflows/...}}`:

```markdown
# workflows/custom/my-workflow.md

## Step 1: Analyze Requirements

Read the specification document at `agent-os/specs/[feature-name]/spec.md`.

Extract the following:
- User stories
- Acceptance criteria
- Technical requirements

## Step 2: Plan Approach

Based on requirements, create a plan for:
- Components to build
- Data models needed
- API endpoints required

## Step 3: Execute

Implement according to plan, following standards.
```

### Testing Commands

```bash
# Compile command
cd ~/test-project
~/agent-os/scripts/project-install.sh --dry-run

# Check compiled output
cat .claude/commands/agent-os/my-command.md

# Verify:
# - Workflows embedded
# - Standards referenced correctly
# - Conditionals resolved based on config
```

---

## Creating Agents

### Agent Structure

```markdown
---
name: my-agent
description: Brief description for agent selection
tools:
  - Read
  - Write
  - Bash
  - WebFetch
---

# My Custom Agent

You are a specialized agent for [specific purpose].

## Your Role

Describe the agent's specific responsibility.

## Instructions

### When You're Invoked

You will be given:
- Input 1
- Input 2

### Your Tasks

1. Task 1
2. Task 2
3. Task 3

### Standards to Follow

Apply these standards:
{{UNLESS standards_as_claude_code_skills}}
- {{agent-os/standards/[category]/[standard].md}}
{{ENDUNLESS standards_as_claude_code_skills}}

### Output Format

Describe expected output format.

## Example

Provide an example workflow.
```

### Agent Best Practices

1. **Single Responsibility**: Each agent should have one clear purpose
2. **Clear Instructions**: Explicit step-by-step instructions
3. **Minimal Tools**: Only tools actually needed
4. **Standards Integration**: Reference relevant standards
5. **Example-Driven**: Include examples of good outputs

---

## Contribution Guidelines

### Before Contributing

1. **Check Existing Issues/Discussions**
   - Search for duplicate ideas
   - Check if already in progress

2. **Start Discussion** (for features)
   - Post in Discussions → Ideas
   - Describe problem and proposed solution
   - Get community feedback
   - Wait for maintainer approval

3. **Check Documentation**
   - Read [CONTRIBUTING.md](../.github/CONTRIBUTING.md)
   - Review [CODE_OF_CONDUCT.md](../.github/CODE_OF_CONDUCT.md)

### Types of Contributions

#### 🐛 Bug Fixes

- Start with Discussion → Bugs
- Include reproduction steps
- PRs welcome with `[bug fix]` prefix

#### 📖 Documentation

- Typos, clarifications always welcome
- Direct PRs OK (no Discussion needed)
- Update version number in docs

#### ✨ Features

- **Must** start with Discussion
- Need maintainer approval before PR
- Consider maintenance burden
- Ensure backward compatibility

#### 🧪 Tests

- **Highly wanted!**
- No Discussion needed
- Follow proposed test structure
- Ensure tests pass on Linux/macOS

### Submitting Changes

```bash
# 1. Create branch
git checkout -b fix/my-bugfix

# 2. Make changes
# Edit files...

# 3. Test thoroughly
./scripts/base-install.sh --dry-run
cd ~/test-project && ~/agent-os/scripts/project-install.sh --dry-run

# 4. Commit
git add .
git commit -m "fix: describe the fix"

# 5. Push
git push origin fix/my-bugfix

# 6. Create PR on GitHub
```

### PR Review Process

1. Maintainer reviews PR
2. May request changes
3. CI checks run (when available)
4. Approved PRs merged to main
5. Included in next release

---

## Development Resources

### Useful Commands

```bash
# Check bash syntax
bash -n script.sh

# Lint markdown
# npm install -g markdownlint-cli
markdownlint README.md

# Find all TODO comments
grep -r "TODO" --include="*.sh" scripts/

# Count lines
wc -l scripts/*.sh

# Check for trailing whitespace
grep -r " $" --include="*.sh" scripts/
```

### Testing Checklist

Before submitting PR:

- [ ] Code follows style guidelines
- [ ] All shell scripts pass `bash -n` check
- [ ] Tested on Linux (required)
- [ ] Tested on macOS (if possible)
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Examples added (if new feature)
- [ ] No hardcoded paths
- [ ] Error messages helpful
- [ ] Backward compatible

### Local Development Tips

**Quick Reinstall**:
```bash
# Alias for quick testing
alias ao-reinstall='~/agent-os-dev/scripts/project-install.sh --re-install --verbose'
```

**Watch for Changes**:
```bash
# Monitor compilation output
watch -n 5 'cat .claude/commands/agent-os/plan-product.md | head -50'
```

**Debug Installation**:
```bash
# Verbose with error capture
~/agent-os-dev/scripts/project-install.sh --verbose 2>&1 | tee install-debug.log
```

---

## Release Process

(For maintainers)

1. **Update Version**:
   ```bash
   # Update config.yml
   nano config.yml
   # Increment version: 2.1.1 → 2.1.2
   ```

2. **Update CHANGELOG**:
   ```bash
   nano CHANGELOG.md
   # Add new version section
   ```

3. **Commit & Tag**:
   ```bash
   git add config.yml CHANGELOG.md
   git commit -m "chore: bump version to 2.1.2"
   git tag v2.1.2
   git push origin main --tags
   ```

4. **Create Release**:
   - GitHub → Releases → New Release
   - Select tag: v2.1.2
   - Title: "Version 2.1.2"
   - Description: Copy from CHANGELOG
   - Publish

5. **Announce**:
   - GitHub Discussions
   - Builder Methods newsletter
   - Social media

---

## Questions?

- **GitHub Discussions**: Q&A category
- **Builder Methods Pro**: [buildermethods.com/pro](https://buildermethods.com/pro)
- **Email**: support@buildermethods.com

Thank you for contributing to Agent OS!
