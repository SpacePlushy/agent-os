# Architecture Overview

This document explains the architecture, design patterns, and internals of Agent OS.

## Table of Contents

- [System Overview](#system-overview)
- [Core Components](#core-components)
- [Design Patterns](#design-patterns)
- [Data Flow](#data-flow)
- [Template System](#template-system)
- [Compilation Process](#compilation-process)
- [Extending Agent OS](#extending-agent-os)

---

## System Overview

Agent OS is a **spec-driven development framework** that transforms unstructured AI agent interactions into systematic, documented workflows.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Base Installation                        │
│                      ~/agent-os/                             │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Profiles │  │ Scripts  │  │  Config  │  │Changelog │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ project-install.sh
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Project Installation                      │
│                  /path/to/your-project/                      │
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │   agent-os/      │         │    .claude/      │         │
│  │  ├── config.yml  │         │  ├── agents/     │         │
│  │  ├── standards/  │         │  └── commands/   │         │
│  │  └── specs/      │         │                  │         │
│  └──────────────────┘         └──────────────────┘         │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ User interaction
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Development Workflow                      │
│                                                               │
│  Plan → Shape → Specify → Create Tasks → Implement → Verify │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Profiles

**Location**: `~/agent-os/profiles/<profile-name>/`

Profiles are template collections containing:
- **Agents**: AI agent definitions
- **Commands**: Workflow entry points
- **Workflows**: Detailed instruction files
- **Standards**: Coding conventions and best practices

**Structure**:
```
profiles/default/
├── agents/
│   ├── product-planner.md
│   ├── spec-shaper.md
│   ├── spec-writer.md
│   ├── tasks-list-creator.md
│   ├── implementer.md
│   ├── implementation-verifier.md
│   ├── spec-initializer.md
│   └── spec-verifier.md
├── commands/
│   ├── plan-product/
│   │   ├── single-agent/
│   │   └── multi-agent/
│   ├── shape-spec/
│   ├── write-spec/
│   ├── create-tasks/
│   ├── implement-tasks/
│   └── orchestrate-tasks/
├── workflows/
│   ├── planning/
│   ├── specification/
│   └── implementation/
└── standards/
    ├── global/
    ├── frontend/
    ├── backend/
    └── testing/
```

### 2. Scripts

**Location**: `~/agent-os/scripts/`

Installation and management scripts:

| Script | Purpose |
|--------|---------|
| `base-install.sh` | Install/update base system |
| `project-install.sh` | Install into project |
| `project-update.sh` | Update project installation |
| `create-profile.sh` | Create custom profile |
| `common-functions.sh` | Shared utilities |

### 3. Configuration

**Files**:
- `~/agent-os/config.yml` (base)
- `<project>/agent-os/config.yml` (project)

Configuration controls:
- Profile selection
- Feature flags (Claude Code, subagents, Skills)
- Default behaviors

### 4. Standards

**Location**: `agent-os/standards/`

Customizable conventions for:
- **Global**: coding-style, error-handling, validation, commenting
- **Frontend**: components, CSS, responsive, accessibility
- **Backend**: API, models, migrations, queries
- **Testing**: test-writing

Standards can be:
- Injected as file references in prompts
- Converted to Claude Code Skills

### 5. Specifications

**Location**: `agent-os/specs/<feature-name>/`

Generated during workflows:
```
specs/user-authentication/
├── mission.md           # Product mission (if plan-product)
├── roadmap.md          # Product roadmap
├── tech-stack.md       # Tech stack decisions
├── requirements.md     # Feature requirements (from shape-spec)
├── spec.md            # Detailed specification (from write-spec)
├── tasks.md           # Task breakdown (from create-tasks)
└── orchestration.yml  # Agent assignments (from orchestrate-tasks)
```

---

## Design Patterns

### 1. Pipeline Pattern

Development flows through sequential phases:

```
Input → Process → Output → (Next Input)
```

**Example**:
```
Product Concept
    ↓ (plan-product)
mission.md, roadmap.md, tech-stack.md
    ↓ (shape-spec)
requirements.md
    ↓ (write-spec)
spec.md
    ↓ (create-tasks)
tasks.md
    ↓ (implement-tasks OR orchestrate-tasks)
Code + Updated tasks.md
```

### 2. Template Substitution Pattern

Commands and agents use template variables:

**Syntax**:
- `{{@path/to/file}}` - Include file contents (with @)
- `{{path/to/file}}` - Reference file path (without @)
- `{{IF condition}}...{{ENDIF condition}}` - Conditional blocks
- `{{UNLESS condition}}...{{ENDUNLESS condition}}` - Negative conditionals
- `{{variable_name}}` - Variable substitution

**Example**:
```markdown
# Command Template
Follow these instructions:

{{@workflows/planning/gather-product-info.md}}

{{IF use_claude_code_subagents}}
Delegate to the product-planner subagent.
{{ENDIF use_claude_code_subagents}}

{{UNLESS use_claude_code_subagents}}
Execute all steps yourself.
{{ENDUNLESS use_claude_code_subagents}}

Apply these standards:
- {{agent-os/standards/global/coding-style.md}}
- {{agent-os/standards/global/commenting.md}}
```

### 3. Dual-Mode Architecture

Commands support both execution modes:

**Single-Agent Mode** (`use_claude_code_subagents: false`):
- One agent executes all work
- Workflows embedded directly in command
- Simpler, more transparent
- Lower token overhead

**Multi-Agent Mode** (`use_claude_code_subagents: true`):
- Work delegated to specialized subagents
- Better context management
- Parallel execution possible
- Higher quality from specialization

### 4. Standards Injection Pattern

Two methods for providing standards:

**File Reference Method** (`standards_as_claude_code_skills: false`):
```markdown
Apply these standards:
- {{agent-os/standards/global/coding-style.md}}
- {{agent-os/standards/frontend/components.md}}
```

**Skills Method** (`standards_as_claude_code_skills: true`):
```markdown
Standards are available as Claude Code Skills.
Discover and apply relevant standards as needed.
```

### 5. Hierarchical Task Breakdown

Tasks organized in groups with dependencies:

```markdown
## Task Group: Frontend

- [ ] Task 1: Create login component
  - [ ] Sub-task 1.1: Design component structure
  - [ ] Sub-task 1.2: Implement form validation
  - [ ] Sub-task 1.3: Add accessibility features

**Standards**: frontend/components.md, frontend/accessibility.md
**Dependencies**: Database group must be complete
```

---

## Data Flow

### Installation Flow

```
1. User runs base-install.sh
   ↓
2. Download from GitHub
   - Profiles
   - Scripts
   - Configuration
   ↓
3. Install to ~/agent-os
   ↓
4. User navigates to project
   ↓
5. User runs project-install.sh
   ↓
6. Load configuration
   - Base config
   - Command-line overrides
   ↓
7. Validate & compile
   - Select profile
   - Apply feature flags
   - Compile templates
   ↓
8. Install to project
   - agent-os/ folder
   - .claude/ folder (if enabled)
   - Compiled commands/agents
```

### Execution Flow (Single-Agent)

```
1. User invokes command
   /implement-tasks
   ↓
2. Command loads compiled instructions
   - Embedded workflows
   - Injected standards
   - Conditional logic
   ↓
3. Agent executes sequentially
   - Read spec.md
   - Read tasks.md
   - Compile standards
   - Implement each task
   - Update tasks.md
   ↓
4. Output
   - Code changes
   - Updated tasks.md
```

### Execution Flow (Multi-Agent)

```
1. User invokes command
   /orchestrate-tasks
   ↓
2. Main agent coordinates
   - Read tasks.md
   - Analyze task groups
   - Create orchestration plan
   ↓
3. Delegate to subagents
   ┌─────────┬─────────┬─────────┐
   │Frontend │Backend  │Database │
   │Subagent │Subagent │Subagent │
   └─────────┴─────────┴─────────┘
   ↓
4. Subagents execute in parallel
   - Each with relevant standards
   - Each updates their task group
   ↓
5. Main agent consolidates
   - Verify integration
   - Update tasks.md
   - Create verification report
```

---

## Template System

### Compilation Steps

1. **Load Template**: Read command/agent markdown file
2. **Include Files**: Replace `{{@path}}` with file contents
3. **Apply Conditions**: Process `{{IF}}` and `{{UNLESS}}` blocks
4. **Substitute Variables**: Replace `{{variable}}` with values
5. **Write Output**: Save compiled file to destination

### Conditional Compilation

Based on configuration flags:

| Variable | True When |
|----------|-----------|
| `use_claude_code_subagents` | Subagents enabled |
| `standards_as_claude_code_skills` | Skills feature enabled |

**Example Logic**:
```markdown
{{IF use_claude_code_subagents}}
## Delegation Strategy

Delegate to these subagents:
- Frontend tasks → frontend-implementer
- Backend tasks → backend-implementer
{{ENDIF use_claude_code_subagents}}

{{UNLESS use_claude_code_subagents}}
## Implementation Strategy

Execute all tasks yourself in this order:
1. Database tasks first
2. Backend tasks second
3. Frontend tasks last
{{ENDUNLESS use_claude_code_subagents}}
```

### Phase Embedding

Single-agent commands can embed phases:

```markdown
# Command: plan-product

## Phase 1: Gather Information
{{@workflows/planning/gather-product-info.md}}

## Phase 2: Create Mission
{{@workflows/planning/create-product-mission.md}}

## Phase 3: Create Roadmap
{{@workflows/planning/create-product-roadmap.md}}

## Phase 4: Create Tech Stack
{{@workflows/planning/create-product-tech-stack.md}}
```

This creates a single, comprehensive command file.

---

## Compilation Process

### Source Structure

```
profiles/default/commands/plan-product/
├── single-agent/
│   ├── plan-product.md         # Main entry point
│   ├── 1-product-concept.md    # Phase 1
│   ├── 2-create-mission.md     # Phase 2
│   ├── 3-create-roadmap.md     # Phase 3
│   └── 4-create-tech-stack.md  # Phase 4
└── multi-agent/
    └── plan-product.md         # Delegation version
```

### Compilation Examples

**Single-Agent Compilation** (`use_claude_code_subagents: false`):
```bash
# Input: profiles/default/commands/plan-product/single-agent/plan-product.md
# Output: .claude/commands/agent-os/plan-product.md

# Compiles with:
# - All phases embedded
# - Standards as file references
# - No delegation logic
```

**Multi-Agent Compilation** (`use_claude_code_subagents: true`):
```bash
# Input: profiles/default/commands/plan-product/multi-agent/plan-product.md
# Output: .claude/commands/agent-os/plan-product.md

# Compiles with:
# - Delegation instructions
# - References to product-planner agent
# - Coordination logic
```

**Skills Compilation** (`standards_as_claude_code_skills: true`):
```bash
# Additional output: .claude/skills/agent-os/*.md

# Standards converted to Skills with:
# - Descriptive titles
# - Use case descriptions
# - Discoverable format
```

---

## Extending Agent OS

### Creating Custom Workflows

1. Create workflow file:
```bash
nano ~/agent-os/profiles/default/workflows/custom/my-workflow.md
```

2. Reference in command:
```markdown
# In command file
{{@workflows/custom/my-workflow.md}}
```

### Creating Custom Agents

1. Create agent file:
```bash
nano ~/agent-os/profiles/default/agents/my-agent.md
```

2. Define agent behavior:
```markdown
---
name: my-agent
description: Custom agent for X
tools:
  - Read
  - Write
  - Bash
---

# My Custom Agent

You are a specialized agent for...

## Instructions
...
```

3. Reference in commands:
```markdown
{{IF use_claude_code_subagents}}
Delegate to the my-agent subagent.
{{ENDIF use_claude_code_subagents}}
```

### Creating Custom Standards

1. Add standard file:
```bash
nano ~/agent-os/profiles/default/standards/custom/my-standard.md
```

2. Reference in workflows/commands:
```markdown
Apply these standards:
- {{agent-os/standards/custom/my-standard.md}}
```

### Creating Custom Profiles

```bash
~/agent-os/scripts/create-profile.sh
```

This creates a new profile that can:
- Inherit from an existing profile
- Override specific files
- Add custom standards
- Customize agents and workflows

---

## Performance Considerations

### Compilation Performance

- Templates compiled once during installation
- No runtime compilation overhead
- Cached file reads during compilation

### Runtime Performance

**Single-Agent Mode**:
- Lower token overhead (no agent delegation)
- Single context window
- Sequential execution

**Multi-Agent Mode**:
- Higher token overhead (multiple agents)
- Smaller context per agent
- Potential parallel execution
- Better quality from specialization

### Network Performance

- Parallel file downloads during installation
- GitHub API caching (15-minute TTL)
- Retry logic for failed downloads

---

## Security Considerations

### Installation Security

- Scripts downloaded from official GitHub repository
- Checksums validated (when available)
- No elevated permissions required
- Sandbox-friendly (no system modifications)

### Execution Security

- No arbitrary code execution
- File operations limited to project directory
- Standards injected as documentation (not code)
- Agent actions require user confirmation (via AI tool)

---

## Next Steps

- [Configuration Reference](configuration.md) - Configure features
- [Installation Guide](installation.md) - Install and setup
- [Development Guide](development.md) - Contribute to Agent OS

For more information, visit [buildermethods.com/agent-os](https://buildermethods.com/agent-os)
