
# C&C Red Alert for CnCNet

This repository contains the source code for the version of Command & Conquer Red Alert packaged with the CnCNet Client.

The source tree has been restored to a state that produces binaries matching the last official patched release, **v3.03**.


## Dependencies

Building from source requires the pre-packaged build dependency archives:

- [CnCNet_RedAlert_Build_Dependencies.zip](https://downloads.cncnet.org/CnCNet_RedAlert_Build_Dependencies.zip)

Extract the contents of the zip archive into the repository root.


## Compiling (Win32 only)

From the repository root, run:

```cmd
MAKE.BAT
```

This builds the **English** localisation by default and produces three executable variants, all copied into `RUN\ENGLISH\`:

| File                  | Variant                    |
|-----------------------|----------------------------|
| `RA95.EXE`            | Release build              |
| `RA95_PLAYTEST.EXE`   | Playtest build             |
| `RA95_INTERNAL.EXE`   | Internal debug build       |

### Building other languages

Set the `BUILD_LANG` environment variable before running `MAKE.BAT` to build a different localisation. Valid values are `ENGLISH`, `FRENCH`, and `GERMAN`:

```cmd
SET BUILD_LANG=FRENCH
MAKE.BAT
```

Binaries are written to `RUN\<LANGUAGE>\`.

To build all three localisations sequentially in one go, run:

```cmd
MAKE_ALL.BAT
```

### Build from a short path

Build from a short directory (for example the repository root on a short drive,
or a path like `C:\RA`). The `IPXPROT` module is assembled by 16-bit TASM running
under the bundled MS-DOS player, and DOS caps a command line at **127 characters**.
That command line embeds the absolute include path (`<root>\WIN32LIB\INCLUDE`), so
a long checkout path (a deeply nested folder) overflows the limit and corrupts the
command line. The symptom is a mangled output filename followed by:

```
**Fatal** IPXPROT.ASM(61) Can't locate file: ipxreal.ibn
```

If you hit this, move the repository to a shorter path, or map one with `SUBST`
and build from there:

```cmd
SUBST X: "%CD%"
X:
MAKE.BAT
```


## Running the game

The build produces only the executables — the original retail game data files (`*.MIX`, movies, audio, etc.) are not part of this repository and must be supplied separately.

Copy the data files from any legitimate Red Alert install into the same `RUN\<LANGUAGE>\` directory as the executable, then launch any of the three `RA95*.EXE` variants from there.

The easiest source for the game data is the C&C Ultimate Collection, available from:

- [EA App](https://www.ea.com/en-gb/games/command-and-conquer/command-and-conquer-the-ultimate-collection/buy/pc)
- [Steam](https://store.steampowered.com/bundle/39394/Command__Conquer_The_Ultimate_Collection/)


## Contributing

Bug reports, suggestions, and pull requests are welcome via GitHub Issues and Pull Requests. Please open an issue to discuss any significant changes before submitting a pull request.


## License

This repository and its contents are licensed under the GPL v3 license, with additional terms applied. Please see [LICENSE.md](LICENSE.md) for details.
