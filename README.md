# sanford/tap

Homebrew formulae by [@sanford](https://github.com/sanford).

```sh
brew install sanford/tap/lsnet
brew install sanford/tap/lsmd
brew install sanford/tap/lshn
```

| Formula | Description |
|---|---|
| [lsnet](https://github.com/sanford/lsnet) | Fast, zero-config LAN scanner that identifies what each device is |
| [lsmd](https://github.com/sanford/lsmd) | Terminal-friendly Markdown (.md) reader built for navigating large projects |
| [lshn](https://github.com/sanford/lshn) | Terminal Hacker News reader: stories, articles and comments on one screen |

## Releasing

Formulae ship with bottles (prebuilt binaries) for macOS on Apple silicon
and for Linux, so installing one doesn't build Rust from source. Intel Macs
build from source: Homebrew has no Intel bottles of Rust to build with.
Bottles are made in pull requests, so a new version goes in through one:

1. Open a pull request that bumps the formula. `brew bump-formula-pr`
   writes it and opens it:

   ```sh
   brew bump-formula-pr --no-fork --tag=v0.8.4 sanford/tap/lsmd
   ```

   If you edit the formula by hand instead, delete its `bottle do` block
   along with changing `url` and `sha256`. A bottle block left over from the
   old version points at bottles that don't exist for the new version.

2. Wait for the `brew test-bot` checks to pass. They build and test the
   formula on each platform and keep the bottles.

3. Publish. This uploads the bottles to a release here, adds the new bottle
   block, and pushes it all to `main`:

   ```sh
   gh workflow run publish.yml -R sanford/homebrew-tap -f pull_request=<number>
   ```

To rebottle a formula that hasn't changed, for example when adding a
platform: open a pull request that touches it (a comment will do), wait for
the checks and publish it, then remove the comment in a commit straight to
`main`. Publishing lands the pull request's commit along with the bottles.
