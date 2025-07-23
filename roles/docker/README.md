# Docker Role

This role installs Docker.io and configures the user to use Docker without sudo.

## Tasks

1. **Install Docker.io** - Installs the latest version of docker.io package
2. **Start Docker service** - Ensures the Docker service is running and enabled on boot
3. **Add user to docker group** - Adds the user to the docker group to allow Docker usage without sudo

## Usage

Include this role in your playbook:

```yaml
- hosts: localhost
  roles:
    - docker
```

## Requirements

- Ubuntu/Debian system
- `my_user` variable must be defined (typically in vars.yml) 