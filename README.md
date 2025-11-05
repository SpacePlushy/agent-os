<img width="1280" height="640" alt="agent-os-og" src="https://github.com/user-attachments/assets/f70671a2-66e8-4c80-8998-d4318af55d10" />

# Agent OS

**Your system for spec-driven agentic development.**

[Agent OS](https://buildermethods.com/agent-os) transforms AI coding agents from confused interns into productive developers. With structured workflows that capture your standards, your stack, and the unique details of your codebase, Agent OS gives your agents the specs they need to ship quality code on the first try—not the fifth.

Use it with:

✅ Claude Code, Cursor, or any other AI coding tool.
✅ New products or established codebases.
✅ Big features, small fixes, or anything in between.
✅ Any language or framework.

---

## 🚀 Quick Start

### Installation

**Option 1: One-liner (recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash
```

**Option 2: Manual installation**
```bash
# Download and run the base installer
curl -O https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh
chmod +x base-install.sh
./base-install.sh
```

This installs Agent OS to `~/agent-os` on your system.

### Install in Your Project

Navigate to your project directory and run:

```bash
cd /path/to/your/project
~/agent-os/scripts/project-install.sh
```

This will:
- Create an `agent-os/` folder in your project
- Install standards and workflows based on your configuration
- Set up Claude Code commands and agents (if enabled)

### Your First Workflow

```bash
# In Claude Code, run:
/plan-product    # Plan your product mission and roadmap
/shape-spec      # Gather requirements for a feature
/write-spec      # Write detailed specification
/create-tasks    # Break down into implementable tasks
/implement-tasks # Implement the tasks with AI
```

---

## 📖 What is Agent OS?

Agent OS is a **spec-driven development framework** that provides:

1. **Structured Workflows** - Step-by-step processes from idea to implementation
2. **Standards Templates** - Best practices for any tech stack
3. **Multi-Agent Orchestration** - Coordinate specialized AI agents for complex work
4. **Documentation Focus** - Clear artifacts at every development phase
5. **Language Agnostic** - Works with any programming language or framework

### Architecture

```
Product Planning → Requirements → Specification → Task Breakdown → Implementation → Verification
     ↓                ↓               ↓                ↓               ↓                ↓
  mission.md    requirements.md   spec.md        tasks.md         code         verification
  roadmap.md                                                                    report
  tech-stack.md
```

Each phase can be executed by:
- **Single-agent mode**: One AI agent handles everything
- **Multi-agent mode**: Specialized agents work on different components

---

## 🎯 Key Features

### 📋 Six Development Phases

| Phase | Command | Purpose | Output |
|-------|---------|---------|--------|
| **Plan** | `/plan-product` | Define product vision | mission.md, roadmap.md, tech-stack.md |
| **Shape** | `/shape-spec` | Gather requirements | requirements.md |
| **Specify** | `/write-spec` | Write detailed spec | spec.md |
| **Break Down** | `/create-tasks` | Decompose into tasks | tasks.md |
| **Implement** | `/implement-tasks` | Single-agent coding | Code + updated tasks |
| **Orchestrate** | `/orchestrate-tasks` | Multi-agent coordination | Code + orchestration.yml |

### 🛠️ Specialized AI Agents

- **product-planner** - Product strategy and roadmapping
- **spec-shaper** - Requirements gathering and research
- **spec-writer** - Technical specification writing
- **tasks-list-creator** - Task decomposition and planning
- **implementer** - Feature implementation
- **implementation-verifier** - Testing and verification

### 📚 Standards System

Agent OS includes customizable standards for:

- **Global**: coding style, error handling, validation, commenting
- **Frontend**: components, CSS, responsive design, accessibility
- **Backend**: API design, models, migrations, queries
- **Testing**: test-writing guidelines

All standards are customizable per project and can be used as:
- File references (injected in prompts)
- Claude Code Skills (discoverable features)

---

## 📁 Project Structure

After installation, your project will have:

```
your-project/
├── agent-os/
│   ├── config.yml              # Project configuration
│   ├── standards/              # Development standards
│   │   ├── global/
│   │   ├── frontend/
│   │   ├── backend/
│   │   └── testing/
│   ├── specs/                  # Feature specifications
│   │   └── [feature-name]/
│   │       ├── mission.md
│   │       ├── requirements.md
│   │       ├── spec.md
│   │       └── tasks.md
│   └── commands/               # CLI commands (optional)
└── .claude/                    # Claude Code integration
    ├── agents/agent-os/        # Specialized agents
    └── commands/agent-os/      # Slash commands
```

---

## ⚙️ Configuration

Edit `~/agent-os/config.yml` to customize defaults:

```yaml
version: 2.1.1

# Enable Claude Code commands in .claude/commands/agent-os/
claude_code_commands: true

# Use Claude Code subagents for multi-agent workflows
use_claude_code_subagents: true

# Enable CLI commands in agent-os/commands/
agent_os_commands: false

# Use Claude Code Skills for standards (vs file references)
standards_as_claude_code_skills: false

# Profile to use (default, or custom profiles)
profile: default
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `claude_code_commands` | Install Claude Code slash commands | `true` |
| `use_claude_code_subagents` | Delegate to specialized subagents | `true` |
| `agent_os_commands` | Install CLI commands | `false` |
| `standards_as_claude_code_skills` | Use Skills feature for standards | `false` |
| `profile` | Profile to use | `default` |

Override defaults when installing in a project:

```bash
~/agent-os/scripts/project-install.sh \
  --claude-code-commands true \
  --use-claude-code-subagents false \
  --profile custom
```

---

## 🔄 Updating

### Update Base Installation

```bash
~/agent-os/scripts/base-install.sh
```

Choose from:
1. Full update (profile + scripts + version)
2. Update default profile only
3. Update scripts only
4. Update config.yml only
5. Delete & reinstall fresh

### Update Project Installation

```bash
cd /path/to/your/project
~/agent-os/scripts/project-update.sh
```

---

## 🎨 Custom Profiles

Create custom profiles for different tech stacks:

```bash
~/agent-os/scripts/create-profile.sh
```

Follow the prompts to:
1. Name your profile
2. Choose base profile to inherit from
3. Customize standards and workflows

Example use cases:
- Ruby on Rails projects
- Next.js + TypeScript apps
- Django + Python projects
- Laravel + PHP applications

---

## 📚 Examples

### Example 1: Planning a New Product

```bash
# In Claude Code
/plan-product

# Agent will ask questions about:
# - Product vision and goals
# - Target users
# - Key features
# - Tech stack

# Outputs: mission.md, roadmap.md, tech-stack.md
```

### Example 2: Building a Feature

```bash
# 1. Gather requirements
/shape-spec

# 2. Write specification
/write-spec

# 3. Create task breakdown
/create-tasks

# 4. Implement (single-agent)
/implement-tasks
```

### Example 3: Complex Multi-Agent Feature

```bash
# For complex features requiring frontend, backend, and database work
/orchestrate-tasks

# Agent will:
# - Analyze task groups
# - Assign specialized agents to each group
# - Coordinate implementation
# - Verify integration
```

---

## 🤝 Use Cases

### For Solo Developers
- Structure AI-assisted development
- Maintain consistent code quality
- Document features as you build
- Track progress through phases

### For Teams
- Align AI agents on team standards
- Consistent specifications across features
- Clear handoff between developers
- Audit trail from vision to code

### For Open Source
- Contributor guidelines for AI agents
- Consistent PR quality
- Feature specification templates
- Onboarding documentation

---

## 📖 Documentation

**Full documentation**: [buildermethods.com/agent-os](https://buildermethods.com/agent-os)

- [Installation Guide](https://buildermethods.com/agent-os/installation)
- [Configuration Reference](https://buildermethods.com/agent-os/configuration)
- [Command Reference](https://buildermethods.com/agent-os/commands)
- [Custom Profiles](https://buildermethods.com/agent-os/profiles)
- [Best Practices](https://buildermethods.com/agent-os/best-practices)

---

## 🔧 Troubleshooting

### Installation Issues

**Problem**: `curl: command not found`
**Solution**: Install curl: `sudo apt-get install curl` (Linux) or `brew install curl` (macOS)

**Problem**: Installation fails with network error
**Solution**: Check internet connection, verify GitHub is accessible: `curl -I https://github.com`

**Problem**: "Agent OS already installed"
**Solution**: Run with `--re-install` flag to delete and reinstall: `~/agent-os/scripts/project-install.sh --re-install`

### Usage Issues

**Problem**: Claude Code commands not appearing
**Solution**: Ensure `claude_code_commands: true` in `~/agent-os/config.yml`, then reinstall in project

**Problem**: Standards not being followed
**Solution**: Customize standards in `agent-os/standards/` and verify they match your stack

**Problem**: Agents not delegating tasks
**Solution**: Check `use_claude_code_subagents: true` in config, verify agents installed in `.claude/agents/agent-os/`

For more help, see [Troubleshooting Guide](https://buildermethods.com/agent-os/troubleshooting)

---

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

**Current version**: 2.1.1

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md) for guidelines.

**Discussions-first workflow**:
- 🐛 Report bugs in Discussions
- 💡 Share feature ideas in Discussions
- 📖 Documentation improvements always welcome
- ✨ Start with a Discussion before submitting feature PRs

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

Copyright © 2024 CasJam Media LLC / Builder Methods

---

## 👨‍💻 Created by Brian Casel @ Builder Methods

Created by Brian Casel, the creator of [Builder Methods](https://buildermethods.com), where Brian helps professional software developers and teams build with AI.

**Free Resources**:
- [Builder Briefing newsletter](https://buildermethods.com)
- [YouTube](https://youtube.com/@briancasel)

**Premium Support**:
- Join [Builder Methods Pro](https://buildermethods.com/pro) for official support and connect with our community of AI-first builders

---

## ⭐ Show Your Support

If Agent OS helps you ship better code with AI, please star this repo and share it with your team!

[⭐ Star on GitHub](https://github.com/buildermethods/agent-os) | [🐦 Share on Twitter](https://twitter.com/intent/tweet?text=Check%20out%20Agent%20OS%20-%20spec-driven%20development%20for%20AI%20coding%20agents&url=https://github.com/buildermethods/agent-os)
