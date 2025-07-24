# Cursor Role

This Ansible role installs the Cursor IDE AppImage on Ubuntu systems.

## Requirements

- Ubuntu system
- Internet connection to download the AppImage
- `/usr/local/bin` in PATH (default on Ubuntu)

## What This Role Does

1. **Downloads Cursor AppImage**: Downloads the specified Cursor AppImage from the official URL
2. **Creates Directory**: Creates `/opt/cursor` directory to store the AppImage
3. **Creates Symlinks**: Creates multiple symlinks for easy access:
   - `/usr/local/bin/cursor` → Direct symlink to the AppImage
   - `/usr/local/bin/cursor-launcher` → Shell script that runs with `--no-sandbox`
   - `/usr/local/bin/cursor-app` → Symlink to the launcher script
4. **Sets Permissions**: Makes the AppImage executable

## Usage

### Basic usage

```yaml
- hosts: ubuntu_setup
  roles:
    - cursor
```

### With main setup

```yaml
- hosts: ubuntu_setup
  roles:
    - vpn
    - cursor
```

## Available Commands

After installation, you can use:

- `cursor` - Direct AppImage execution
- `cursor-app` - AppImage with `--no-sandbox` flag
- `cursor-launcher` - Same as cursor-app

## Behavior

The role will:

1. Check if the `cursor` command already exists on the system
2. If not found, download the Cursor AppImage
3. Create necessary directories and symlinks
4. Create a launcher script with `--no-sandbox` flag
5. Make everything available in the system PATH

The role is idempotent and will skip installation if Cursor is already present.

## Example Playbook

```yaml
---
- hosts: ubuntu_setup
  roles:
    - cursor
```

Run with:

```bash
udo ansible-playbook -i hosts cursor-role.yml
``` 