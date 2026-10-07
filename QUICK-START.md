# Quick Start (transcryptito)

Use this fork with the `transcryptito` command.

## 1) Validate your environment

Required tools:

- Bash
- Git
- OpenSSL

Optional but recommended before production rollout:

```bash
shellcheck transcrypt transcryptito
/tmp/bats-core/bin/bats tests/   # ignore se não tiver bats instalado
```

## 2) Install command

From the repository root (`transcryptito` is a single self-contained script):

```bash
sudo install -m 0755 transcryptito /usr/local/bin/transcryptito
transcryptito --version
```

## 3) Set password via environment variable

```bash
export TRANSCRYPTITO_PASSWORD='change-me'
```

For named contexts, use:

```bash
export TRANSCRYPTITO_PASSWORD_SUPER_SECRET='change-me-too'
```

## 4) Initialize and verify

Inside your Git repository:

```bash
transcryptito --cipher=aes-256-cbc --yes
transcryptito --display
```

Verify helper scripts and hooks were installed:

```bash
test -x .git/crypt/transcrypt
test -x .git/hooks/pre-commit
test -x .git/hooks/pre-commit-crypt
```

## 5) Encrypt files

```bash
transcryptito --add sensitive_file
git add .gitattributes sensitive_file
git commit -m "Add encrypted sensitive_file"
```

## Production notes

- `transcryptito` is a single self-contained script.
- Git filters and hooks execute `.git/crypt/transcrypt`, which is installed during init.
- Validate in a staging clone first, then roll out to production repositories.
