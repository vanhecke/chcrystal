# chcrystal

Changes the current Crystal version.

## Features

* Updates `$PATH`.
  * Adds both `bin/` and `embedded/bin/` directories to `$PATH` (for `shards`
    and other bundled tools).
* Sets `$CRYSTAL_ROOT` and `$CRYSTAL_VERSION`.
* Calls `hash -r` to clear the command-lookup hash-table.
* Fuzzy matching of Crystals by name.
* Defaults to the system Crystal.
* Optionally supports auto-switching and the `.crystal-version` file.
* Supports [bash] and [zsh].
* Small (~90 LOC).
* Has tests.

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Crystals be installed into your home directory.
* Does not automatically switch Crystals by default.

## Requirements

* [bash] >= 3 or [zsh]

## Install

```shell
wget https://github.com/vanhecke/chcrystal/archive/v0.1.0/chcrystal-0.1.0.tar.gz
tar -xzvf chcrystal-0.1.0.tar.gz
cd chcrystal-0.1.0/
sudo make install
```

### From Source

```shell
git clone https://github.com/vanhecke/chcrystal.git
cd chcrystal/
sudo make install
```

## Configuration

Add the following to the `~/.bashrc` or `~/.zshrc` file:

```bash
source /usr/local/share/chcrystal/chcrystal.sh
```

### System Wide

If you wish to enable chcrystal system-wide, add the following to
`/etc/profile.d/chcrystal.sh`:

```bash
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  source /usr/local/share/chcrystal/chcrystal.sh
  ...
fi
```

### Crystals

When chcrystal is first loaded by the shell, it will auto-detect Crystals
installed in `/opt/crystals/` and `~/.crystals/`. After installing new Crystals,
you _must_ restart the shell before chcrystal can recognize them.

For Crystals installed in non-standard locations, simply append their paths to
the `CRYSTALS` variable:

```bash
source /usr/local/share/chcrystal/chcrystal.sh

CRYSTALS+=(
  /opt/crystal-nightly
  "$HOME/src/crystal"
)
```

### Auto-Switching

If you want chcrystal to auto-switch the current version of Crystal when you
`cd` between your different projects, simply load `auto.sh` in `~/.bashrc` or
`~/.zshrc`:

```bash
source /usr/local/share/chcrystal/chcrystal.sh
source /usr/local/share/chcrystal/auto.sh
```

chcrystal will check the current and parent directories for a `.crystal-version`
file.

### Default Crystal

If you wish to set a default Crystal, simply call `chcrystal` in
`~/.bash_profile` or `~/.zprofile`:

```
chcrystal 1.19
```

If you have enabled auto-switching, simply create a `.crystal-version` file:

```
echo "1.19.1" > ~/.crystal-version
```

## Examples

List available Crystals:

```
$ chcrystal
   crystal-1.18.2
   crystal-1.19.1
```

Select a Crystal:

```
$ chcrystal 1.19.1
$ chcrystal
   crystal-1.18.2
 * crystal-1.19.1
$ crystal --version
Crystal 1.19.1 [a3178c32b] (2026-01-20)
$ shards --version
Shards 0.20.0 (2025-12-19)
```

Switch back to system Crystal:

```
$ chcrystal system
```

## Uninstall

After removing the chcrystal configuration:

```shell
sudo make uninstall
```

## Credits

chcrystal is inspired by and structurally based on [chruby] by [postmodern].
The architecture, shell integration patterns, and auto-switching mechanism are
directly adapted from his work.

* [postmodern](https://github.com/postmodern) for creating [chruby] and
  [ruby-install], which served as the blueprint for this project.

[bash]: https://www.gnu.org/software/bash/
[zsh]: https://www.zsh.org/

[crystal-install]: https://github.com/vanhecke/crystal-install#readme
[chruby]: https://github.com/postmodern/chruby#readme
[ruby-install]: https://github.com/postmodern/ruby-install#readme
[postmodern]: https://github.com/postmodern
