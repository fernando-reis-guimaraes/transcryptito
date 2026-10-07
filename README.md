# transcryptito

`transcryptito` transparently encrypts sensitive files inside a Git repository.
Encrypted files are stored as ciphertext in Git (and on GitHub), but appear as
normal plaintext in your working copy. Anyone who clones the repository
without the password only sees encrypted data.

It uses OpenSSL symmetric ciphers combined with Git's built-in
clean/smudge filters. This repository is a fork of
[elasticdog/transcrypt](https://github.com/elasticdog/transcrypt).

## What is different in this fork

Compared to upstream, this fork:

- loads passwords from environment variables instead of reading/storing them in local git config
- supports context-specific variables using `TRANSCRYPTITO_PASSWORD_<CONTEXT>`
- prompts for password at runtime (silent input) when env vars are unset for direct `transcryptito` usage
- avoids persisting passwords in `.git/config`

## 1. Requirements

- Bash
- Git
- OpenSSL (`openssl version` should print a version; LibreSSL on macOS works too)

Check them:

```bash
git --version
bash --version
openssl version
```

## 2. Installing

`transcryptito` is a single self-contained script. Install it once per machine:

```bash
git clone https://github.com/frginbox/transcryptito.git
cd transcryptito
sudo install -m 0755 transcryptito /usr/local/bin/transcryptito
transcryptito --version
```

## 3. Setting your password

The password is **never stored in the repository**. Provide it through the
environment variable `TRANSCRYPTITO_PASSWORD`:

```bash
export TRANSCRYPTITO_PASSWORD='a-long-passphrase-only-your-team-knows'
```

Keep this passphrase in a team password manager. If the variable is unset and
you run `transcryptito` directly in a terminal, it prompts for the password
(silent input). Non-interactive Git operations (filters, hooks) cannot prompt,
so always export the variable in scripts and CI.

## 4. Initializing a new repository

Inside your Git repository:

```bash
cd my-project

export TRANSCRYPTITO_PASSWORD='a-long-passphrase-only-your-team-knows'

transcryptito --cipher=aes-256-cbc --yes

transcryptito --display
```

The repository must have no uncommitted changes when you initialize.
Initialization installs a helper copy under `.git/crypt/` and a pre-commit
hook that rejects accidental commits of unencrypted sensitive files.

## 5. Encrypting files (daily use)

Mark a file pattern for encryption, then commit normally — Git encrypts the
file automatically when it is staged:

```bash
transcryptito --add .env
git add .gitattributes .env
git commit -m "Add encrypted .env"
```

From then on just use Git as usual. Encryption and decryption happen
transparently on `git add`, `git checkout`, `git diff`, and merges.

To verify a file really is encrypted in Git while remaining readable locally:

```bash
cat .env                  # plaintext (your working copy)
git show HEAD:.env         # base64 ciphertext starting with U2FsdGVk
transcryptito --list      # lists every encrypted file
transcryptito --show-raw .env
```

## 6. Joining an existing encrypted repository (another machine)

```bash
git clone <repository-url>
cd <repository>

export TRANSCRYPTITO_PASSWORD='the-same-passphrase'
transcryptito --cipher=aes-256-cbc --yes
```

`transcryptito` forces a checkout of the encrypted files, which decrypts them
in your working copy. Run `transcryptito --display` to confirm the cipher and
password.

## 7. Contexts (optional, advanced)

Contexts encrypt different file groups with different passwords — for example
one password for the whole team and another for admins:

```bash
# initialize the "admins" context with its own password
export TRANSCRYPTITO_PASSWORD_ADMINS='the-admins-passphrase'
transcryptito --context=admins --cipher=aes-256-cbc --yes

# check it and list all contexts
transcryptito --context=admins --display
transcryptito --list-contexts
```

You can also initialize directly from the environment:

```bash
# default context
export TRANSCRYPTITO_PASSWORD='abc 123'
transcryptito --display

# named context: super-secret
export TRANSCRYPTITO_PASSWORD_SUPER_SECRET='321cba'
transcryptito --context=super-secret --display
```

Context names must be lowercase ASCII starting with a letter
(`admins`, `super-secret`, `staging`). The environment variable for a context
named `super-secret` is `TRANSCRYPTITO_PASSWORD_SUPER_SECRET`. Files for a
context use `filter=crypt-<context>` attributes in `.gitattributes`.

## 8. Command reference

| Command | Purpose |
|---|---|
| `transcryptito --cipher=CIPHER --yes` | initialize the repository |
| `transcryptito --display` (`-d`) | show cipher and password |
| `transcryptito --add PATTERN` | mark a file pattern for encryption |
| `transcryptito --list` (`-l`) | list encrypted files |
| `transcryptito --show-raw FILE` (`-s`) | show stored ciphertext of a file |
| `transcryptito --context=NAME` (`-C`) | operate on a named context |
| `transcryptito --list-contexts` | list all contexts |
| `transcryptito --rekey` (`-r`) | re-encrypt everything with a new password |
| `transcryptito --flush-credentials` (`-f`) | remove the local password (files show as encrypted again) |
| `transcryptito --uninstall` (`-u`) | remove all configuration from the repository |
| `transcryptito --upgrade` | update helper scripts in the repo after upgrading the tool |
| `transcryptito --version` (`-v`) | print the version |
| `transcryptito --help` (`-h`) | full help, also available as `man transcrypt.1` from this repo |

## 9. Golden rules

1. **Password outside the repo, always.** Never commit it, never put it in an
   encrypted file. It lives in the environment or a password manager.
2. **Mark first, then stage.** A sensitive file committed before
   `transcryptito --add` lands in history as plaintext, and scrubbing history
   afterwards is painful.
3. **Start from a clean repository** (nothing uncommitted) before init, rekey,
   flush, upgrade, or uninstall. Commit or stash first.
4. **Don't touch `.git/crypt/` or the `pre-commit` hook.** They are managed
   automatically; the hook protects you from committing plaintext by accident.
5. **If the origin rekeyed**, flush locally, pull, and re-initialize with the
   new credentials:
   `transcryptito --flush-credentials --yes`, `git pull`, then initialize
   again with the new password.

## For maintainers

For fork-specific maintainer instructions (local validation, usage flow, and
package publishing guidance including Homebrew and Arch PKGBUILD), see:

- [FORK_BUILD_AND_PUBLISH.md](FORK_BUILD_AND_PUBLISH.md)
- [QUICK-START.md](QUICK-START.md)

## Original upstream documentation

If you want the full original documentation and upstream examples, read:

- [Upstream README (elasticdog/transcrypt)](https://github.com/elasticdog/transcrypt/blob/main/README.md)
- [Upstream INSTALL](https://github.com/elasticdog/transcrypt/blob/main/INSTALL.md)

## License

This project is distributed under the same license as upstream transcrypt (MIT).
See [LICENSE](LICENSE).
