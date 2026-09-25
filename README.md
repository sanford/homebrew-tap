# sanford/tap

Homebrew formulae by [@sanford](https://github.com/sanford).

```sh
brew install sanford/tap/lsnet
```

| Formula | Description |
|---|---|
| [lsnet](https://github.com/sanford/lsnet) | Fast, zero-config LAN scanner that identifies what each device is |

## Releasing a new version

1. Tag the release in the project repo: `git tag -a vX.Y.Z -m "lsnet X.Y.Z" && git push origin vX.Y.Z`
2. Get the tarball checksum:
   `curl -sL https://github.com/sanford/lsnet/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256`
3. Update `url` and `sha256` in `Formula/lsnet.rb`, then check it:
   `brew install --build-from-source sanford/tap/lsnet && brew test lsnet && brew audit --strict --online sanford/tap/lsnet`
