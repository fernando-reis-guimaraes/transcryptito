# Build, Use, and Publish this Fork

This project is a Bash script, so there is no compilation/build artifact step.
"Build" for this fork means validating script quality and tests, then publishing
the script and docs.

## 1) Build/validate locally

From the repository root:

```bash
# Lint
shellcheck transcrypt
shellcheck transcryptito

# Tests (same as CI)
/tmp/bats-core/bin/bats tests/
```

If `bats` is not installed:

```bash
git clone https://github.com/bats-core/bats-core.git /tmp/bats-core-repo
mkdir -p /tmp/bats-core
bash /tmp/bats-core-repo/install.sh /tmp/bats-core
```

## 2) Use this fork

Option A (run directly from repo):

```bash
./transcryptito --help
```

Option B (install in PATH):

```bash
sudo install -m 0755 transcryptito /usr/local/bin/transcryptito
```

With this fork, set password(s) via env vars:

```bash
# default context
export TRANSCRYPTITO_PASSWORD='correct horse battery staple'

# named context example: super-secret -> TRANSCRYPTITO_PASSWORD_SUPER_SECRET
export TRANSCRYPTITO_PASSWORD_SUPER_SECRET='another password'
```

Then initialize/use as usual:

```bash
transcryptito --cipher=aes-256-cbc --yes
transcryptito --display
```

## 3) Publish this fork

### 3.1 Create releases in this repo

1. Tag a version in this fork (for example `v2.3.2-transcryptito.1`).
2. Push the tag and create a GitHub Release.
3. Use release tarball URLs in downstream package definitions.

### 3.2 Publish on Homebrew (recommended for macOS)

Use a custom tap for your org (for example `frginbox`):

1. Create a tap repo:
   - `github.com/frginbox/homebrew-tap`
2. Add a formula at `Formula/transcryptito.rb`.
3. Point `url` to your fork release tarball and set `sha256`.

Example formula:

```ruby
class Transcryptito < Formula
  desc "Transparently encrypt files within a git repository"
  homepage "https://github.com/frginbox/transcryptito"
  url "https://github.com/frginbox/transcryptito/archive/refs/tags/v2.3.2-transcryptito.1.tar.gz"
  sha256 "<REPLACE_WITH_REAL_SHA256>"
  license "MIT"

  def install
    bin.install "transcryptito"
    man1.install "man/transcrypt.1"
  end

  test do
    assert_match "transcryptito", shell_output("#{bin}/transcryptito --version")
  end
end
```

Install from your tap:

```bash
brew tap frginbox/tap
brew install transcryptito
```

### 3.3 Publish for another package manager (Arch Linux example)

This repository already includes a PKGBUILD template at:
`contrib/packaging/pacman/PKGBUILD`.

To publish your fork version:

1. Update PKGBUILD `source`, `sha256sums`, `pkgver`, and package name if needed.
2. Build locally with `makepkg -sic`.
3. Publish in your internal package workflow or AUR-style repo.
