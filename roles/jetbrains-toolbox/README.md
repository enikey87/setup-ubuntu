# JetBrains Toolbox Role

This Ansible role installs the JetBrains Toolbox in the user's home directory.

## Requirements

- Ubuntu system
- Internet connection to download the Toolbox
- User home directory accessible

## What This Role Does

1. **Downloads JetBrains Toolbox**: Downloads the specified version from JetBrains CDN
2. **Extracts to User Home**: Extracts the tar.gz file to `~/jetbrains-toolbox/`
3. **Creates Symlink**: Creates `jbt` symlink in `~/.local/bin/` for easy access
4. **Cleans Up**: Removes the downloaded tar.gz file after extraction
5. **User-Specific Installation**: Installs in user's home directory, not system-wide

## Installation Location

- **Toolbox Directory**: `~/jetbrains-toolbox/`
- **Executable**: `~/jetbrains-toolbox/jetbrains-toolbox`
- **Symlink**: `~/.local/bin/jbt` → `~/jetbrains-toolbox/jetbrains-toolbox`

## Usage

### Basic usage

```yaml
- hosts: ubuntu_setup
  roles:
    - jetbrains-toolbox
```

### With main setup

```yaml
- hosts: ubuntu_setup
  roles:
    - vpn
    - cursor
    - jetbrains-toolbox
```

## Available Commands

After installation, you can use:

- `jbt` - Launches JetBrains Toolbox

## Behavior

The role will:

1. Check if the `jbt` command already exists on the system
2. If not found, download the JetBrains Toolbox tar.gz file
3. Extract it to the user's home directory
4. Create a symlink in `~/.local/bin/` for easy access
5. Clean up the downloaded archive

The role is idempotent and will skip installation if JetBrains Toolbox is already present.

## Example Playbook

```yaml
---
- hosts: ubuntu_setup
  roles:
    - jetbrains-toolbox
```

Run with:

```bash
sudo ansible-playbook -i hosts jetbrains-toolbox-role.yml
```

## Notes

- Installation is user-specific (not system-wide)
- The symlink is created in `~/.local/bin/` which should be in the user's PATH
- The toolbox will be available for the current user only 