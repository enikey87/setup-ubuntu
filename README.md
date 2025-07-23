# TODO

- fix: don't use snap versions of nomad and vault because they can't read files from hidden folders, use official repos instead
- feat: automate VAULT_TOKEN lookup
- doc: write actual instructions for nomad and vault integrations
- fix: cursor -> cursor.bin, cursor-app -> cursor
- feat: automate certs update via cron (every 28 days)
- fix: add songsterr root trusted cert to linux system trusted certs store
- doc: actuallize README

# Install

```shell
sudo apt install python3 ansible -y
ansible-playbook install.yml -K
```

# Add your SSH key to GitHub (short version)
1. Copy your public key to clipboard (requires xclip):
   ```bash
   cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
   ```
2. Go to https://github.com/settings/keys
3. Click "New SSH key", give it a name, and paste your key.
4. Save.
5. Test with:
   ```bash
   ssh -T git@github.com
   ```

# Configure npm
```shell
# take from 1P
npm login --registry https://npm.terra.songsterr.com
```
# Post installation

```shell
ansible-playbook postinstall.yml -K
```

# Post configuration

```shell
# take from 1P
vault login -method=userpass username=person
vault token lookup -format=json | jq -r .data.id > ~/.vault-token
chmod 600 ~/.vault-token

# run every month
sh ./access/nomad_cli.sh
# run and follow instructions every month
sh ./access/nomad_browser.sh
```
