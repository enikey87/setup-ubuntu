# Outline VPN Connection Guide

This guide explains how to connect to an Outline VPN server using shadowsocks-rust with ss-redir for system-wide proxy functionality.

## Prerequisites

- Outline VPN server access credentials
- Ubuntu/Debian system
- Root or sudo privileges

## Installation

### 1. Install shadowsocks-rust

```bash
# Install shadowsocks-rust using cargo
cargo install shadowsocks-rust

# Or download pre-built binary
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.15.0/shadowsocks-v1.15.0.x86_64-unknown-linux-gnu.tar.xz
tar -xf shadowsocks-v1.15.0.x86_64-unknown-linux-gnu.tar.xz
sudo mv ss* /usr/local/bin/
```

### 2. Get Your Outline Server URL

From your Outline VPN client, you can get the server URL in this format:
```
ss://chacha20-ietf-poly1305:your-password@your-outline-server-ip:port
```

Or you can extract the individual components:
- **Server IP**: Your Outline server IP address
- **Port**: Your Outline server port
- **Password**: Your Outline server password
- **Method**: Usually `chacha20-ietf-poly1305` for Outline servers

**Note**: The `--server-url` parameter eliminates the need for a separate configuration file, making setup much simpler.

## Connection Methods

### Method 1: Direct ss-redir with --server-url (Recommended)

This method provides system-wide proxy functionality using the server URL directly:

```bash
# Start ss-redir with server URL
sudo ss-redir --server-url "ss://chacha20-ietf-poly1305:your-password@your-outline-server-ip:port" -l 127.0.0.1:1080 -f /var/run/shadowsocks-rust.pid

# Check if it's running
ps aux | grep ss-redir
```

**Alternative format with separate parameters:**
```bash
sudo ss-redir -s your-outline-server-ip -p port -k your-password -m chacha20-ietf-poly1305 -l 127.0.0.1:1080 -f /var/run/shadowsocks-rust.pid
```

### Method 2: Using systemd service with --server-url

Create a systemd service for automatic startup:

```bash
sudo nano /etc/systemd/system/shadowsocks-rust.service
```

Add the following content:

```ini
[Unit]
Description=Shadowsocks Rust Proxy Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ss-redir --server-url "ss://chacha20-ietf-poly1305:your-password@your-outline-server-ip:port" -l 127.0.0.1:1080
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

**Alternative format with separate parameters:**
```ini
[Unit]
Description=Shadowsocks Rust Proxy Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ss-redir -s your-outline-server-ip -p port -k your-password -m chacha20-ietf-poly1305 -l 127.0.0.1:1080
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable shadowsocks-rust
sudo systemctl start shadowsocks-rust
sudo systemctl status shadowsocks-rust
```

## iptables Configuration

To redirect traffic through the proxy, configure iptables rules:

```bash
# Create a new chain for shadowsocks
sudo iptables -t nat -N SHADOWSOCKS

# Ignore shadowsocks server IP
sudo iptables -t nat -A SHADOWSOCKS -d your-outline-server-ip -j RETURN

# Ignore LAN IPs
sudo iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
sudo iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

# Redirect TCP traffic to shadowsocks
sudo iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080

# Apply the chain to OUTPUT
sudo iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
```

Replace `your-outline-server-ip` with your actual Outline server IP address.

## Testing the Connection

### 1. Check if ss-redir is running

```bash
sudo netstat -tlnp | grep 1080
```

### 2. Test with curl

```bash
# Test your public IP
curl -s https://ipinfo.io/ip

# Test with proxy
curl -s --socks5 127.0.0.1:1080 https://ipinfo.io/ip
```

### 3. Test DNS resolution

```bash
# Test DNS through proxy
nslookup google.com 127.0.0.1:1080
```

## Troubleshooting

### Common Issues

1. **Permission denied**: Make sure you're running with sudo
2. **Port already in use**: Check if port 1080 is available
3. **Connection refused**: Verify your Outline server credentials
4. **DNS issues**: Configure DNS to use 8.8.8.8 or 1.1.1.1

### Debug Commands

```bash
# Check shadowsocks logs
sudo journalctl -u shadowsocks-rust -f

# Check iptables rules
sudo iptables -t nat -L -n -v

# Test connectivity
telnet your-outline-server-ip your-port

# Check process
ps aux | grep ss-redir
```

## Security Considerations

1. **Firewall**: Ensure your firewall allows the Outline server connection
2. **DNS leaks**: Consider using a DNS proxy or VPN DNS
3. **Logs**: Monitor logs for any suspicious activity
4. **Updates**: Keep shadowsocks-rust updated

## Disabling the Proxy

To disable the proxy:

```bash
# Stop the service
sudo systemctl stop shadowsocks-rust

# Remove iptables rules
sudo iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS
sudo iptables -t nat -F SHADOWSOCKS
sudo iptables -t nat -X SHADOWSOCKS

# Kill the process if running
sudo pkill ss-redir
```

## Additional Configuration

### DNS Configuration

To prevent DNS leaks, configure your system to use a secure DNS:

```bash
# Edit resolv.conf
sudo nano /etc/resolv.conf

# Add these lines
nameserver 8.8.8.8
nameserver 1.1.1.1
```

### Browser Configuration

For browser-specific proxy configuration:

1. Install browser extensions like "Proxy SwitchyOmega"
2. Configure SOCKS5 proxy: 127.0.0.1:1080
3. Set up auto-switch rules for specific domains

## References

- [Shadowsocks Rust GitHub](https://github.com/shadowsocks/shadowsocks-rust)
- [Outline VPN Documentation](https://getoutline.org/get-started/)
- [iptables Documentation](https://netfilter.org/documentation/) 