```
sudo apt install python3 ansible -y
sudo ansible-playbook -i hosts setup.yml

# install deps for cursor in appimage format
sudo apt install libfuse2

# Set your GitHub username
git config --global user.name "enikey87"

# Set your GitHub email
git config --global user.email "enikey87@gmail.com"

# (Optional) Check your configuration
git config --global --list

# Generate an SSH key 
ssh-keygen -t ed25519 -C "enikey87@gmail.com" -f ~/.ssh/id_ed25519 -N ""
# Add your SSH key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

# Add your SSH key to GitHub (short version)
1. Copy your public key to clipboard (requires xclip):
   ```bash
   cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
   ```
   If you don't have xclip, install it with:
   ```bash
   sudo apt install xclip
   ```
2. Go to https://github.com/settings/keys
3. Click "New SSH key", give it a name, and paste your key.
4. Save.
5. Test with:
   ```bash
   ssh -T git@github.com
   ```

# Go to GitHub SSH keys settings
#Open your browser and go to:
#https://github.com/settings/keys
#  Add a new SSH key
#Click the "New SSH key" or "Add SSH key" button.
#In the "Title" field, enter a name (e.g., "My Laptop" or "Work PC").
#In the "Key" field, paste the public key you copied in step 1.
#Click "Add SSH key".