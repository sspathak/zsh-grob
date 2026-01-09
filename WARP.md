# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

`zsh-grob` (Git Rebase Onto Branch) is an interactive wrapper around `git rebase --onto`. It uses `fzf` to create a step-by-step workflow for moving commit ranges between branches, with the killer use case being management of stacked pull requests.

The project provides two distribution methods:
1. **git-grob**: Standalone executable invoked as `git grob` (installable via Homebrew or manual install)
2. **zsh-grob.plugin.zsh**: Oh-My-Zsh plugin invoked as `grob`

## Architecture

### Core Files
- **git-grob**: Standalone executable with shebang (`#!/usr/bin/env zsh`). Uses `exit` instead of `return` for error handling.
- **zsh-grob.plugin.zsh**: Oh-My-Zsh plugin that defines a `grob()` function. Uses `return` for flow control.

Both files contain identical logic with minor differences in exit/return handling.

### Key Technical Patterns

**Interactive Flow**: The function implements a three-step wizard:
1. Branch selection (target destination)
2. Commit selection (oldest commit to move, inclusive)
3. Preview and confirmation

**Preview System**: Uses `fzf`'s `--preview` flag with inline shell commands to show:
- Branch history during branch selection
- Rich commit details (author, date, stats, full diff) during commit selection
- Constructs complex preview commands using heredoc-style string interpolation

**Commit Range Calculation**: Instead of requiring users to understand `HEAD~N` syntax, the plugin:
1. Uses `git log --oneline | grep -nF` to find the line number of the selected commit
2. Converts that to `HEAD~N` format for the rebase command
3. Builds `git rebase --onto <target> HEAD~N <flags...>`

**Cross-Platform Compatibility**: The preview command in lines 44-57 carefully handles:
- `sed` escape sequences that work on both BSD (macOS) and GNU (Linux)
- `awk` string escaping for Zsh context (note the `\"` patterns)
- `tput` for ANSI colors instead of hardcoded escape codes

## Development Commands

### Testing the Standalone Executable
```bash
# Test the git-grob executable directly
./git-grob

# Test with flags
./git-grob -i
./git-grob --autosquash

# Test as git subcommand (requires git-grob to be in PATH)
export PATH="$PWD:$PATH"
git grob
```

### Testing the Plugin
```zsh
# After making changes, reload the function
source zsh-grob.plugin.zsh

# Test in a git repository with branches
grob

# Test with flags
grob -i
grob --autosquash
```

### Creating Test Scenarios
To test stacked PR scenarios (the primary use case):

```bash
# Create test branches
git checkout -b branch_A main
# Make commits...
git checkout -b branch_B branch_A
# Make more commits...

# Simulate A being updated
git checkout branch_A
git commit --amend  # or add more commits
git checkout branch_B

# Now test: grob should help rebase B onto new A
```

### Installation Testing

**Homebrew (local testing):**
```bash
# Test the formula locally before publishing
brew install --build-from-source ./git-grob.rb
git grob  # Test it works
brew uninstall git-grob  # Clean up
```

**Manual installation:**
```bash
# Install to local bin
cp git-grob /usr/local/bin/
chmod +x /usr/local/bin/git-grob
git grob  # Test it works
```

**Oh-My-Zsh plugin:**
```bash
# Copy to custom plugins directory
cp zsh-grob.plugin.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/grob/grob.plugin.zsh
source ~/.zshrc
grob  # Test it works
```

## Code Style Notes

**Zsh Idioms**: This plugin uses Zsh-specific features:
- `read -k 1` for single-character input
- Array syntax: `${#extra_flags[@]}` and `"${extra_flags[@]}"`
- Conditional regex matching: `[[ "$confirm" =~ ^[Yy]$ ]]`

**Terminal Formatting**: Uses `tput` consistently for all terminal control (bold, colors, reset). When editing, maintain this pattern rather than using raw ANSI codes.

**Preview Command Construction**: Lines 44-57 contain a complex multi-line string for `fzf --preview`. When editing:
- Inner quotes must be escaped for Zsh (`\"`)
- The `sed` command uses `\$d` to delete the last line (works on both BSD/GNU)
- Color codes use `tput` wrapped in command substitution within the string

## Dependencies

- **Zsh**: Required (this is a Zsh plugin)
- **fzf**: Required for interactive selection (checked at runtime)
- **Git**: Required (assumed to be present)

## Common Modifications

**Adjusting Preview Window Size**: Modify `--preview-window` flags:
- Branch preview (line 34): `--preview-window=up:40%`
- Commit preview (line 63): `--preview-window=up:6:wrap`

**Changing Preview Content**: Edit the `preview_cmd` variable (lines 44-57). Remember to test on both macOS and Linux if changing `sed` or `awk` usage.

**Adding Git Flags**: The `extra_flags` array is passed through to the final rebase command. All unknown arguments to `grob` are treated as flags for `git rebase`.

## Important Technical Notes

**Commented Code**: Lines 100-194 contain a commented-out previous version. This appears to be kept for reference (possibly showing the evolution of the sed/awk escaping fixes mentioned in line 43).

**Dirty Worktree Check**: Lines 25-28 prevent rebasing with uncommitted changes. This is a safety feature and should be preserved.

**Base Reference Calculation**: Line 71 (`base_ref="HEAD~$commit_index"`) is the critical calculation that translates the user's selection into the correct rebase syntax. The index is 1-based (from grep -n), which correctly maps to HEAD~N.

## Distribution and Release

### Creating a Homebrew Release
1. Tag a new version: `git tag v1.0.0 && git push origin v1.0.0`
2. Generate SHA256 of release tarball: `curl -sL https://github.com/sspathak/zsh-grob/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256`
3. Update `git-grob.rb` with the correct version and SHA256
4. Create a tap repository at `github.com/sspathak/homebrew-tap`
5. Copy `git-grob.rb` to the tap repository

### File Structure

```
zsh-grob/
├── git-grob             # Standalone executable (can be invoked as 'git grob')
├── zsh-grob.plugin.zsh  # Oh-My-Zsh plugin (defines grob() function)
├── git-grob.rb          # Homebrew formula
├── README.md            # User documentation
├── WARP.md              # AI agent guidance
├── LICENSE              # MIT License
└── file.txt             # Test file (not part of distribution)
```
