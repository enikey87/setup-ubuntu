# Install

```shell
sudo apt install python3 ansible -y
sudo ansible-playbook install.yml
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

# Post installation

```shell
sudo ansible-playbook postinstall.yml
```
