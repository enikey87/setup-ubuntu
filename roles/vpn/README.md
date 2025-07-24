# VPN Role

This Ansible role installs the outline-cli VPN client on Ubuntu systems.

## Requirements

- Ubuntu system
- Git (will be installed if not present)
- Internet connection to clone the repository

## Role Variables

The following variables are defined in `defaults/main.yml`:

- `vpn_repository`: The Git repository URL for outline-cli
- `vpn_temp_dir`: Temporary directory for cloning the repository
- `vpn_install_script`: Name of the install script
- `vpn_binary_path`: Path where the VPN binary will be installed

## Usage

### Basic usage

```yaml
- hosts: ubuntu_setup
  roles:
    - vpn
```

### With custom variables

```yaml
- hosts: ubuntu_setup
  vars:
    vpn_repository: "https://github.com/custom/outline-cli"
    vpn_temp_dir: "/opt/outline-cli"
  roles:
    - vpn
```

## Behavior

The role will:

1. Check if the `vpn` command already exists on the system
2. If not found, install git (if needed)
3. Clone the outline-cli repository
4. Make the install script executable
5. Run the install script with `-y` flag for automatic confirmation
6. Clean up temporary files

The role is idempotent and will skip installation if the VPN client is already present.

## Example Playbook

```yaml
---
- hosts: ubuntu_setup
  roles:
    - vpn
```

Run with:

```bash
sudo ansible-playbook -i hosts vpn-role.yml
``` 