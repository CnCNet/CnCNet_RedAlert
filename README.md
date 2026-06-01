
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

### Private CnCNet build

A separate ENGLISH build that also pulls in the private CnCNet sources is produced
by:

```cmd
MAKE_CNCNET.BAT
```

Output is staged into `RUN\CNCNET\`, separate from the standard localisation builds.

This requires access to the private sources, which are not part of this
repository and are only available to internal CnCNet developers. Provide them in
one of two ways:

- check the private repository out into `CODE\CNCNET\`, or
- point `CNCNET_RED_ALERT_PRIVATE_REPO` in a local `.env` file at a separate clone
  (see [.env.example](.env.example)).

Without the private sources present, `MAKE.BAT` / `MAKE_ALL.BAT` build normally and
this step is simply unavailable.

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


## Developing in VS Code

The repository ships a VS Code workspace (`.vscode/`). Open the folder in VS Code
(or run `OPEN_VSCODE.BAT`); it will offer to install the recommended C/C++
extension.

**Build tasks** (`Terminal > Run Build Task`, or `Ctrl+Shift+B`, then pick one):

| Task | Action |
|------|--------|
| Build (MAKE.BAT, ENGLISH)        | English build |
| Build all languages (MAKE_ALL.BAT) | English / French / German |
| Build CnCNet (MAKE_CNCNET.BAT)   | Private CnCNet build (requires the private sources) |
| Compile current file (Game Code Only) | Clean-recompile just the open `CODE\*.cpp` file — fast syntax/iteration check |

Watcom compiler diagnostics are parsed into the **Problems** panel.

**IntelliSense:** configurations for each variant (ENGLISH / FRENCH / GERMAN /
CnCNet) are provided; switch the active one from the status bar or via
`C/C++: Select a Configuration`. Include paths and defines mirror the build, and
the standard is pinned to the toolchain's (C++98 / C89).

**Launching:** open the **Run and Debug** view (`Ctrl+Shift+D`), choose
**Run English (RA95)** or **Run CnCNet (RA95)** from the dropdown, and press `F5`.
Each launches `RA95.EXE` from its `RUN\<variant>\` folder with `-CD.`, so the
retail data files must already be present in that folder (see
[Running the game](#running-the-game)).

This is a convenience for quickly launching the built game — **not** a full
debugging experience. The game is built with Watcom, whose debug information the
VS Code debugger cannot read, so source-level breakpoints will not bind; it will
still launch the game and surface crashes/call stacks.


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
