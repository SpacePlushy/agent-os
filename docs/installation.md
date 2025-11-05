# Installation Guide

This guide covers all installation methods and scenarios for Agent OS.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Base Installation](#base-installation)
- [Project Installation](#project-installation)
- [Installation Options](#installation-options)
- [Verification](#verification)
- [Uninstallation](#uninstallation)

---

## Prerequisites

### Required

- **Bash 4.0+**: Agent OS uses bash scripts
- **curl**: For downloading files from GitHub
- **Git** (recommended): For version control

### Optional

- **Claude Code**: For integrated AI coding experience
- **jq or Python 3**: For JSON parsing (one of these)

### Checking Prerequisites

```bash
# Check bash version
bash --version

# Check curl
curl --version

# Check git
git --version

# Check jq (optional)
jq --version

# Check python (optional)
python3 --version
```

---

## Base Installation

The base installation creates `~/agent-os` on your system with all profiles, scripts, and standards.

### Method 1: One-liner (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh | bash
```

### Method 2: Manual Download

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh

# Make it executable
chmod +x base-install.sh

# Run it
./base-install.sh
```

### Method 3: Clone Repository

```bash
# Clone the repository
git clone https://github.com/buildermethods/agent-os.git ~/agent-os

# Navigate to the directory
cd ~/agent-os

# Run the base install
./scripts/base-install.sh
```

### Installation Flags

```bash
# Verbose output
./base-install.sh --verbose

# Show help
./base-install.sh --help
```

### What Gets Installed

The base installation creates:

```
~/agent-os/
├── config.yml                  # Base configuration
├── scripts/                    # Installation scripts
│   ├── base-install.sh
│   ├── project-install.sh
│   ├── project-update.sh
│   ├── create-profile.sh
│   └── common-functions.sh
├── profiles/                   # Profile templates
│   └── default/
│       ├── agents/             # AI agent definitions
│       ├── commands/           # Command workflows
│       ├── workflows/          # Detailed instructions
│       └── standards/          # Coding standards
├── CHANGELOG.md
└── README.md
```

---

## Project Installation

After base installation, install Agent OS into your project.

### Basic Project Installation

```bash
# Navigate to your project
cd /path/to/your/project

# Run project installer
~/agent-os/scripts/project-install.sh
```

### Installation with Options

```bash
# Use specific profile
~/agent-os/scripts/project-install.sh --profile custom

# Disable Claude Code subagents
~/agent-os/scripts/project-install.sh --use-claude-code-subagents false

# Enable CLI commands instead of Claude Code
~/agent-os/scripts/project-install.sh \
  --claude-code-commands false \
  --agent-os-commands true

# Dry run (preview without installing)
~/agent-os/scripts/project-install.sh --dry-run

# Verbose output
~/agent-os/scripts/project-install.sh --verbose

# Re-install (delete and reinstall)
~/agent-os/scripts/project-install.sh --re-install
```

### What Gets Installed in Your Project

```
your-project/
├── agent-os/
│   ├── config.yml              # Project configuration
│   ├── standards/              # Copied from profile
│   │   ├── global/
│   │   ├── frontend/
│   │   ├── backend/
│   │   └── testing/
│   ├── specs/                  # Created as you work
│   └── commands/               # If agent-os-commands enabled
└── .claude/                    # If claude-code-commands enabled
    ├── agents/agent-os/        # If subagents enabled
    └── commands/agent-os/
```

---

## Installation Options

### Configuration Matrix

| Option | Description | Default |
|--------|-------------|---------|
| `--profile` | Profile to use | `default` |
| `--claude-code-commands` | Install Claude Code commands | `true` |
| `--use-claude-code-subagents` | Use specialized subagents | `true` |
| `--agent-os-commands` | Install CLI commands | `false` |
| `--standards-as-claude-code-skills` | Use Skills for standards | `false` |
| `--dry-run` | Preview without installing | `false` |
| `--verbose` | Show detailed output | `false` |
| `--re-install` | Delete and reinstall | `false` |

### Common Installation Scenarios

#### Scenario 1: Claude Code with Subagents (Default)

```bash
~/agent-os/scripts/project-install.sh
```

Installs:
- ✅ Claude Code commands in `.claude/commands/agent-os/`
- ✅ Subagents in `.claude/agents/agent-os/`
- ✅ Standards in `agent-os/standards/`
- ❌ CLI commands

#### Scenario 2: Claude Code without Subagents

```bash
~/agent-os/scripts/project-install.sh --use-claude-code-subagents false
```

Installs:
- ✅ Claude Code commands (single-agent mode)
- ❌ Subagents
- ✅ Standards

Use when you want simpler, faster execution without delegation.

#### Scenario 3: CLI-Only (No Claude Code)

```bash
~/agent-os/scripts/project-install.sh \
  --claude-code-commands false \
  --agent-os-commands true
```

Installs:
- ❌ Claude Code integration
- ✅ CLI commands in `agent-os/commands/`
- ✅ Standards

Use with Cursor, Windsurf, or other AI tools.

#### Scenario 4: Skills-Based Standards

```bash
~/agent-os/scripts/project-install.sh \
  --standards-as-claude-code-skills true
```

Installs:
- ✅ Claude Code commands
- ✅ Standards as Claude Code Skills (discoverable)
- ❌ Standards file references in prompts

After installation, run:
```bash
# In Claude Code
/improve-skills
```

---

## Verification

### Verify Base Installation

```bash
# Check installation directory
ls -la ~/agent-os

# Check version
cat ~/agent-os/config.yml | grep version

# List profiles
ls ~/agent-os/profiles/

# Verify scripts are executable
ls -l ~/agent-os/scripts/*.sh
```

### Verify Project Installation

```bash
# Check agent-os folder
ls -la agent-os/

# Check configuration
cat agent-os/config.yml

# Check standards
ls agent-os/standards/

# Check Claude Code installation (if enabled)
ls .claude/commands/agent-os/
ls .claude/agents/agent-os/
```

### Test Installation

```bash
# In Claude Code (if installed)
/plan-product

# Or manually run a command
cat .claude/commands/agent-os/plan-product.md
```

---

## Updating

### Update Base Installation

```bash
~/agent-os/scripts/base-install.sh
```

The script will detect existing installation and offer options:
1. **Full update** - Updates profile, scripts, and version
2. **Update default profile only**
3. **Update scripts only**
4. **Update config.yml only**
5. **Delete & reinstall fresh**
6. **Cancel**

### Update Project Installation

```bash
cd /path/to/your/project
~/agent-os/scripts/project-update.sh
```

Options:
- `--overwrite-all` - Overwrite all files
- `--overwrite-standards` - Overwrite standards only
- `--overwrite-commands` - Overwrite commands only
- `--overwrite-agents` - Overwrite agents only
- `--dry-run` - Preview changes
- `--verbose` - Detailed output

---

## Uninstallation

### Uninstall from Project

```bash
# Navigate to your project
cd /path/to/your/project

# Remove Agent OS files
rm -rf agent-os/
rm -rf .claude/agents/agent-os/
rm -rf .claude/commands/agent-os/
```

### Uninstall Base Installation

```bash
# Remove base installation
rm -rf ~/agent-os

# Optionally remove backups
rm -rf ~/agent-os.backup
```

---

## Troubleshooting Installation

### Issue: curl command not found

**Solution**:
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install curl

# macOS
brew install curl

# CentOS/RHEL
sudo yum install curl
```

### Issue: Permission denied

**Solution**:
```bash
# Make script executable
chmod +x base-install.sh

# Or run with bash explicitly
bash base-install.sh
```

### Issue: Download fails with network error

**Solutions**:
1. Check internet connection
2. Verify GitHub is accessible:
   ```bash
   curl -I https://github.com
   ```
3. Check for firewall/proxy blocking
4. Try manual download method

### Issue: Installation incomplete

**Solution**:
```bash
# Run with verbose flag to see what's failing
./base-install.sh --verbose

# Or check the GitHub repository directly
curl -I https://api.github.com/repos/buildermethods/agent-os/git/trees/main
```

### Issue: Already installed message

**Solutions**:
```bash
# Choose update option from menu
./base-install.sh

# Or force reinstall in project
~/agent-os/scripts/project-install.sh --re-install
```

---

## Advanced Installation

### Custom Installation Location

To install to a custom location (not recommended):

```bash
# Download base-install.sh
curl -O https://raw.githubusercontent.com/buildermethods/agent-os/main/scripts/base-install.sh

# Edit the script to change BASE_DIR
nano base-install.sh
# Change: BASE_DIR="$HOME/agent-os"
# To: BASE_DIR="/custom/path/agent-os"

# Run modified installer
./base-install.sh
```

**Note**: This requires updating references in other scripts.

### Offline Installation

For environments without internet access:

```bash
# On a machine with internet:
# 1. Clone repository
git clone https://github.com/buildermethods/agent-os.git
tar -czf agent-os.tar.gz agent-os/

# 2. Transfer agent-os.tar.gz to offline machine

# On offline machine:
# 3. Extract
tar -xzf agent-os.tar.gz -C ~/

# 4. No need to run base-install.sh (already have files)

# 5. Install in projects normally
cd /path/to/project
~/agent-os/scripts/project-install.sh
```

---

## Next Steps

After successful installation:

1. **Customize Configuration**: Edit `~/agent-os/config.yml`
2. **Customize Standards**: Edit files in `~/agent-os/profiles/default/standards/`
3. **Install in Projects**: Run `project-install.sh` in your projects
4. **Start Using**: Run `/plan-product` in Claude Code or explore commands
5. **Read Documentation**: Visit [buildermethods.com/agent-os](https://buildermethods.com/agent-os)

---

For more help, see:
- [Configuration Guide](configuration.md)
- [Troubleshooting Guide](troubleshooting.md)
- [Architecture Overview](architecture.md)
