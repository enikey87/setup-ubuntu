# System setup

```shell
# required deps to run ansible
sudo apt install python3 ansible -y
# these steps doesn't require any credentials and manual configuration
ansible-playbook setup.yml -K
```

# Configure (manual)

### git
1. Copy your public key to clipboard (requires xclip):
   ```bash
   cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
   ```
2. Go to https://github.com/settings/keys
3. Click "New SSH key", give it a name, and paste your key.
4. Save.

### npm
use `~/.npmrc` from 1P or npm login:
```shell
# take from 1P
npm login --registry https://npm.terra.songsterr.com
```
### vault + nomad

```shell
# take from 1P
vault login -method=userpass username=person
vault token lookup -format=json | jq -r .data.id > ~/.vault-token
chmod 600 ~/.vault-token

# run every month
sh ./access/nomad_cli.sh
# run and follow instructions every month
sh ./access/nomad_browser.sh
# fix missing certs in Chrome, but unfortunately this does not work still
sh ./patches/trust-songsterr.sh
```

# Setup dev-tools
```shell
# connect to vpn to bypass country restrictions
sudo vpn add "ss://<your_outline_access_key>" "vpn0"
sudo vpn connect vpn0

ansible-playbook configure.yml -K

sudo vpn disconnect
```

# TODO (later)

- fix: don't use snap versions of nomad and vault because they can't read files from hidden folders, use official repos instead
- fix: https://a2.ops.songsterr.com:4646/ cert is not trusted in Chrome
- feat: automate vault login and VAULT_TOKEN lookup
- feat: automate access to nomad from CLI via cron (every 28 days)
- feat: automate nomad person.p12 cert update (access/nomad_browser.sh)
- feat: automate access to nomad from Chrome via cron (every 28 days)
