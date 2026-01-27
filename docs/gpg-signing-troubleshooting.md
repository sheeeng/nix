# GPG Signing Troubleshooting

## GPG Database Lock Timeout

### Symptom

```
error: gpg failed to sign the data:
gpg: Note: database_open 134217901 waiting for lock (held by 2472) ...
gpg: Note: database_open 134217901 waiting for lock (held by 2472) ...
gpg: keydb_search failed: Connection timed out
gpg: skipped "F104C3F659438426!": Connection timed out
gpg: signing failed: Connection timed out

fatal: failed to write commit object
```

### Root Cause

The GPG keybox database is locked by another process. This typically happens when:

1. **Duplicate `keyboxd` daemons** are running (common after crashes or hibernation)
2. **Stale lock files** remain from previous GPG sessions
3. **GPG agent** became unresponsive

### Diagnosis

Check for running GPG processes:

```bash
ps aux | grep -E "gpg|keyboxd" | grep -v grep
```

If you see multiple `keyboxd` processes, that's the problem:

```
llee  2472  keyboxd --homedir /home/llee/.gnupg --daemon
llee  4141  keyboxd --homedir /home/llee/.gnupg --daemon  # duplicate!
```

Check for stale lock files:

```bash
ls -la ~/.gnupg/public-keys.d/.#lk* ~/.gnupg/public-keys.d/pubring.db.lock 2>/dev/null
```

### Solution

#### Quick Fix

```bash
# Kill all GPG daemons cleanly
gpgconf --kill all

# Remove stale lock files
rm -f ~/.gnupg/public-keys.d/.#lk* ~/.gnupg/public-keys.d/pubring.db.lock

# Test GPG signing
echo "test" | gpg --clearsign
```

#### Force Kill (If Quick Fix Fails)

```bash
# Force kill all GPG-related processes
pkill -9 -u $USER keyboxd
pkill -9 -u $USER gpg-agent

# Remove stale lock files
rm -f ~/.gnupg/public-keys.d/.#lk* ~/.gnupg/public-keys.d/pubring.db.lock

# Verify daemons are stopped
ps aux | grep -E "keyboxd|gpg-agent" | grep -v grep

# Test GPG signing
echo "test" | gpg --clearsign
```

### Prevention

1. **Avoid hibernation with active GPG operations**
2. **Clean shutdown** ensures proper daemon termination
3. **Periodic cleanup** of stale lock files if issues recur

### Related Files

| File/Directory | Purpose |
|----------------|---------|
| `~/.gnupg/` | GPG home directory |
| `~/.gnupg/public-keys.d/` | Keybox database directory |
| `~/.gnupg/public-keys.d/pubring.db` | Public key database |
| `~/.gnupg/public-keys.d/.#lk*` | Lock files (can become stale) |
| `~/.gnupg/public-keys.d/pubring.db.lock` | Database lock file |

### Commands Reference

```bash
# Kill all GPG daemons
gpgconf --kill all

# List GPG keys
gpg --list-keys

# Test signing with specific key
echo "test" | gpg --clearsign --default-key YOUR_KEY_ID

# Check GPG agent status
gpg-connect-agent 'getinfo version' /bye

# Restart GPG agent
gpg-connect-agent reloadagent /bye
```
