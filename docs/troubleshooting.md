# Troubleshooting Guide

Common issues and solutions for Agent OS.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Configuration Issues](#configuration-issues)
- [Command Execution Issues](#command-execution-issues)
- [Standards Issues](#standards-issues)
- [Claude Code Issues](#claude-code-issues)
- [Performance Issues](#performance-issues)
- [Getting Help](#getting-help)

---

## Installation Issues

### Issue: `curl: command not found`

**Symptom**: Installation script fails immediately

**Solution**:
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install curl

# macOS (with Homebrew)
brew install curl

# CentOS/RHEL/Fedora
sudo yum install curl

# Or use dnf
sudo dnf install curl
```

**Verify**:
```bash
curl --version
```

---

### Issue: `Permission denied` when running scripts

**Symptom**: Cannot execute installation scripts

**Solution 1**: Make script executable
```bash
chmod +x base-install.sh
./base-install.sh
```

**Solution 2**: Run with bash explicitly
```bash
bash base-install.sh
```

**Solution 3**: Check directory permissions
```bash
# Verify you can write to home directory
touch ~/test-file && rm ~/test-file
```

---

### Issue: Network errors during download

**Symptom**: `Failed to download` or `Connection refused`

**Solutions**:

1. **Check internet connection**:
```bash
ping -c 3 google.com
curl -I https://github.com
```

2. **Check GitHub accessibility**:
```bash
curl -I https://api.github.com
```

3. **Check for rate limiting**:
```bash
curl https://api.github.com/rate_limit
```

4. **Try with verbose flag**:
```bash
./base-install.sh --verbose
```

5. **Check proxy/firewall**:
```bash
# If behind proxy, set environment variables
export https_proxy=http://proxy.example.com:8080
./base-install.sh
```

6. **Use offline installation**:
```bash
# On machine with internet
git clone https://github.com/buildermethods/agent-os.git
tar -czf agent-os.tar.gz agent-os/

# Transfer to offline machine and extract
tar -xzf agent-os.tar.gz -C ~/
```

---

### Issue: Installation incomplete or partial

**Symptom**: Some files missing after installation

**Diagnosis**:
```bash
# Check what was installed
ls -la ~/agent-os
ls -la ~/agent-os/profiles/default

# Check for errors
./base-install.sh --verbose 2>&1 | tee install.log
cat install.log
```

**Solutions**:

1. **Re-run installation**:
```bash
~/agent-os/scripts/base-install.sh
# Choose: Delete & reinstall fresh
```

2. **Check disk space**:
```bash
df -h ~
```

3. **Check file count**:
```bash
# Should have ~78 files total
find ~/agent-os -type f | wc -l
```

---

### Issue: "Agent OS already installed"

**Symptom**: Installation blocked by existing installation

**Solutions**:

**Option 1**: Update existing installation
```bash
~/agent-os/scripts/base-install.sh
# Choose update option from menu
```

**Option 2**: Reinstall from scratch
```bash
~/agent-os/scripts/base-install.sh
# Choose: Delete & reinstall fresh
```

**Option 3**: Manual cleanup
```bash
# Backup first
cp -r ~/agent-os ~/agent-os.manual-backup

# Remove and reinstall
rm -rf ~/agent-os
./base-install.sh
```

---

## Configuration Issues

### Issue: Commands not appearing in Claude Code

**Symptom**: Slash commands like `/plan-product` don't show up

**Diagnosis**:
```bash
# Check if Claude Code commands are enabled
cat ~/agent-os/config.yml | grep claude_code_commands

# Check if commands were installed
ls .claude/commands/agent-os/
```

**Solutions**:

1. **Enable Claude Code commands**:
```bash
# Edit base config
nano ~/agent-os/config.yml
# Set: claude_code_commands: true

# Reinstall in project
cd /path/to/project
~/agent-os/scripts/project-install.sh --re-install
```

2. **Verify .claude directory**:
```bash
# Should exist and have commands
ls -la .claude/commands/agent-os/

# If missing, reinstall
~/agent-os/scripts/project-install.sh --claude-code-commands true
```

3. **Restart Claude Code**:
```bash
# In VS Code, reload window
# Command Palette: Developer: Reload Window
```

---

### Issue: Subagents not delegating

**Symptom**: Main agent doing all work instead of delegating

**Diagnosis**:
```bash
# Check if subagents are enabled
cat ~/agent-os/config.yml | grep use_claude_code_subagents

# Check if agents were installed
ls .claude/agents/agent-os/
```

**Solutions**:

1. **Enable subagents**:
```bash
nano ~/agent-os/config.yml
# Set: use_claude_code_subagents: true

cd /path/to/project
~/agent-os/scripts/project-install.sh --re-install
```

2. **Verify agents installed**:
```bash
# Should have 8 agent files
ls -l .claude/agents/agent-os/
```

3. **Check dependencies**:
```bash
# Subagents require Claude Code commands
cat ~/agent-os/config.yml | grep claude_code_commands
# Must be: true
```

---

### Issue: Standards not being applied

**Symptom**: AI not following standards in agent-os/standards/

**Diagnosis**:
```bash
# Check if standards exist
ls agent-os/standards/

# Check config
cat agent-os/config.yml
```

**Solutions**:

1. **Verify standards are customized**:
```bash
# Standards should match your tech stack
cat agent-os/standards/global/tech-stack.md
```

2. **Check Skills configuration**:
```bash
# If using Skills
cat ~/agent-os/config.yml | grep standards_as_claude_code_skills

# If true, run improve-skills
# In Claude Code: /improve-skills
```

3. **Explicitly reference standards**:
```bash
# In your spec.md or prompts, explicitly mention:
"Follow the coding standards in agent-os/standards/"
```

4. **Update project installation**:
```bash
~/agent-os/scripts/project-update.sh --overwrite-standards
```

---

### Issue: Wrong profile being used

**Symptom**: Standards don't match expected tech stack

**Diagnosis**:
```bash
# Check which profile is configured
cat ~/agent-os/config.yml | grep profile
cat agent-os/config.yml | grep profile
```

**Solutions**:

1. **Change profile in base config**:
```bash
nano ~/agent-os/config.yml
# Set: profile: rails  # or your desired profile
```

2. **Reinstall project with correct profile**:
```bash
~/agent-os/scripts/project-install.sh --profile rails --re-install
```

3. **List available profiles**:
```bash
ls ~/agent-os/profiles/
```

4. **Create custom profile if needed**:
```bash
~/agent-os/scripts/create-profile.sh
```

---

## Command Execution Issues

### Issue: Command not found

**Symptom**: `/plan-product` shows "command not found"

**Diagnosis**:
```bash
# Check if command file exists
ls .claude/commands/agent-os/plan-product.md

# Check Claude Code config
cat .claude/config.json
```

**Solutions**:

1. **Reinstall commands**:
```bash
~/agent-os/scripts/project-update.sh --overwrite-commands
```

2. **Verify Claude Code commands enabled**:
```bash
cat agent-os/config.yml | grep claude_code_commands
# Should be: true
```

3. **Check file permissions**:
```bash
ls -l .claude/commands/agent-os/
# Files should be readable
```

---

### Issue: Command fails with error

**Symptom**: Command starts but errors out

**Diagnosis**:
```bash
# Check command file for syntax errors
cat .claude/commands/agent-os/<command-name>.md

# Look for template issues
grep -n "{{" .claude/commands/agent-os/<command-name>.md
```

**Solutions**:

1. **Update to latest version**:
```bash
# Update base
~/agent-os/scripts/base-install.sh

# Update project
~/agent-os/scripts/project-update.sh --overwrite-all
```

2. **Check for missing files**:
```bash
# Verify all standards exist
ls agent-os/standards/global/
ls agent-os/standards/frontend/
ls agent-os/standards/backend/
```

3. **Reinstall from scratch**:
```bash
rm -rf agent-os/ .claude/agents/agent-os/ .claude/commands/agent-os/
~/agent-os/scripts/project-install.sh
```

---

### Issue: Workflow creates files in wrong location

**Symptom**: Files created in unexpected directories

**Solutions**:

1. **Check current directory**:
```bash
# Always run commands from project root
pwd
# Should be: /path/to/your-project
```

2. **Verify agent-os folder exists**:
```bash
ls agent-os/
# Should show: config.yml, standards/, specs/
```

3. **Create specs directory if missing**:
```bash
mkdir -p agent-os/specs
```

---

## Standards Issues

### Issue: Standards file not found

**Symptom**: Agent reports "cannot find standards file"

**Diagnosis**:
```bash
# Check standards directory
ls -la agent-os/standards/

# Check for specific standard
ls agent-os/standards/global/coding-style.md
```

**Solutions**:

1. **Reinstall standards**:
```bash
~/agent-os/scripts/project-update.sh --overwrite-standards
```

2. **Check profile has standards**:
```bash
ls ~/agent-os/profiles/default/standards/
```

3. **Manually copy if needed**:
```bash
cp -r ~/agent-os/profiles/default/standards/* agent-os/standards/
```

---

### Issue: Standards not customized for tech stack

**Symptom**: Generic standards don't match your project

**Solutions**:

1. **Edit tech-stack standard**:
```bash
nano agent-os/standards/global/tech-stack.md

# Update with your actual stack:
# - Framework: Rails / Next.js / Django
# - Database: PostgreSQL / MySQL / MongoDB
# - Frontend: React / Vue / Hotwire
# etc.
```

2. **Customize other standards**:
```bash
# Edit each standard to match your preferences
nano agent-os/standards/global/coding-style.md
nano agent-os/standards/frontend/components.md
```

3. **Create custom profile**:
```bash
~/agent-os/scripts/create-profile.sh
# Then reinstall with custom profile
~/agent-os/scripts/project-install.sh --profile my-custom --re-install
```

---

## Claude Code Issues

### Issue: Claude Code not recognizing Agent OS

**Symptom**: No slash commands, no agents visible

**Diagnosis**:
```bash
# Check Claude Code is installed
which claude

# Check .claude directory
ls -la .claude/
```

**Solutions**:

1. **Ensure Claude Code is installed**:
   - Visit [Claude Code documentation](https://docs.claude.com/en/docs/claude-code)
   - Install via VS Code extension

2. **Check directory structure**:
```bash
# Should have:
.claude/
├── agents/
│   └── agent-os/
└── commands/
    └── agent-os/
```

3. **Reload VS Code window**:
   - Command Palette (Cmd/Ctrl+Shift+P)
   - "Developer: Reload Window"

4. **Check VS Code settings**:
   - Ensure Claude Code extension is enabled
   - Check for workspace settings conflicts

---

### Issue: Skills not working

**Symptom**: Skills not appearing or not being used

**Diagnosis**:
```bash
# Check if Skills are enabled
cat ~/agent-os/config.yml | grep standards_as_claude_code_skills

# Check if Skills files exist
ls .claude/skills/agent-os/
```

**Solutions**:

1. **Enable Skills**:
```bash
nano ~/agent-os/config.yml
# Set: standards_as_claude_code_skills: true

cd /path/to/project
~/agent-os/scripts/project-install.sh --standards-as-claude-code-skills true --re-install
```

2. **Run improve-skills command**:
```bash
# In Claude Code
/improve-skills

# This enhances skill descriptions for better discovery
```

3. **Verify Skills directory**:
```bash
ls .claude/skills/agent-os/
# Should have standards converted to skills
```

---

## Performance Issues

### Issue: Installation is very slow

**Symptom**: Takes >5 minutes to install

**Diagnosis**:
```bash
# Test download speed
time curl -o /dev/null https://github.com/buildermethods/agent-os/raw/main/README.md
```

**Solutions**:

1. **Check network connection**:
```bash
# Test speed
curl -o /dev/null https://github.com

# Check for rate limiting
curl https://api.github.com/rate_limit
```

2. **Use faster mirror** (if available):
```bash
# Future feature - not yet implemented
```

3. **Use offline installation**:
```bash
# Clone once, use locally
git clone https://github.com/buildermethods/agent-os.git ~/agent-os
```

---

### Issue: Commands execute slowly

**Symptom**: Claude Code commands take long time

**Possible Causes**:
- Large context from standards
- Many subagent delegations
- Complex workflows

**Solutions**:

1. **Disable subagents for simpler tasks**:
```bash
# Per project
~/agent-os/scripts/project-install.sh --use-claude-code-subagents false --re-install
```

2. **Use Skills instead of file references**:
```bash
# Reduces upfront context
~/agent-os/scripts/project-install.sh --standards-as-claude-code-skills true --re-install
/improve-skills
```

3. **Trim unused standards**:
```bash
# Remove standards you don't need
rm agent-os/standards/frontend/*  # If backend-only project
rm agent-os/standards/backend/*   # If frontend-only project
```

---

## Getting Help

### Self-Diagnosis

1. **Check version**:
```bash
cat ~/agent-os/config.yml | head -1
```

2. **Check configuration**:
```bash
cat ~/agent-os/config.yml
cat agent-os/config.yml
```

3. **Check installation status**:
```bash
ls -la ~/agent-os
ls -la agent-os/
ls -la .claude/
```

4. **Run with verbose logging**:
```bash
~/agent-os/scripts/project-install.sh --dry-run --verbose
```

---

### Collecting Debug Information

When reporting issues, include:

```bash
# System info
uname -a
bash --version

# Agent OS version
cat ~/agent-os/config.yml | head -3

# Configuration
cat ~/agent-os/config.yml
cat agent-os/config.yml 2>/dev/null || echo "No project config"

# Directory structure
ls -la ~/agent-os/
ls -la agent-os/ 2>/dev/null || echo "No agent-os folder"
ls -la .claude/ 2>/dev/null || echo "No .claude folder"

# Error logs (if any)
cat install.log 2>/dev/null || echo "No install log"
```

---

### Community Support

- **Discussions**: [GitHub Discussions](https://github.com/buildermethods/agent-os/discussions)
- **Bug Reports**: [GitHub Issues](https://github.com/buildermethods/agent-os/issues)
- **Documentation**: [buildermethods.com/agent-os](https://buildermethods.com/agent-os)

### Premium Support

- **Builder Methods Pro**: [buildermethods.com/pro](https://buildermethods.com/pro)
  - Guaranteed response times
  - Priority bug fixes
  - Custom profile assistance
  - Direct support from creator

---

### Known Issues

See [CHANGELOG.md](../CHANGELOG.md) for known issues in current version.

Check [GitHub Issues](https://github.com/buildermethods/agent-os/issues) for reported problems and workarounds.

---

## Preventive Maintenance

### Regular Updates

```bash
# Update base installation monthly
~/agent-os/scripts/base-install.sh

# Update project installations as needed
cd /path/to/project
~/agent-os/scripts/project-update.sh
```

### Configuration Backups

```bash
# Backup base config before changes
cp ~/agent-os/config.yml ~/agent-os/config.yml.backup

# Backup project config
cp agent-os/config.yml agent-os/config.yml.backup
```

### Custom Profile Backups

```bash
# Backup custom profiles
tar -czf ~/agent-os-profiles-backup.tar.gz ~/agent-os/profiles/
```

---

For more help, see:
- [Installation Guide](installation.md)
- [Configuration Reference](configuration.md)
- [Architecture Overview](architecture.md)
