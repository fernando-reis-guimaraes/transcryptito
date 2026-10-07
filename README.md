# transcryptito

This repository is a fork of [elasticdog/transcrypt](https://github.com/elasticdog/transcrypt).

It keeps the same core goal (transparent Git clean/smudge encryption) with fork-specific behavior focused on safer password handling.

## What is different in this fork

Compared to upstream, this fork:

- loads passwords from environment variables instead of reading/storing them in local git config
- supports context-specific variables using `TRANSCRYPTITO_PASSWORD_<CONTEXT>`
- prompts for password at runtime (silent input) when env vars are unset for direct `transcryptito` usage
- avoids persisting passwords in `.git/config`

Examples:

```bash
# default context
export TRANSCRYPTITO_PASSWORD='abc 123'
transcryptito --display

# named context: super-secret
export TRANSCRYPTITO_PASSWORD_SUPER_SECRET='321cba'
transcryptito --context=super-secret --display
```

## Build, validate, and use this fork

For fork-specific instructions (local validation, usage flow, and package publishing guidance including Homebrew and Arch PKGBUILD), see:

- [FORK_BUILD_AND_PUBLISH.md](FORK_BUILD_AND_PUBLISH.md)
- [QUICK-START.md](QUICK-START.md)

## Original upstream documentation

If you want the full original documentation and upstream examples, read:

- [Upstream README (elasticdog/transcrypt)](https://github.com/elasticdog/transcrypt/blob/main/README.md)
- [Upstream INSTALL](https://github.com/elasticdog/transcrypt/blob/main/INSTALL.md)

## License

This project is distributed under the same license as upstream transcrypt (MIT).
See [LICENSE](LICENSE).
