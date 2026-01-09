# grob - Interactive Git Rebase Tool for Stacked PRs

**Git Rebase Onto Branch (grob)** is an interactive command-line tool that makes `git rebase --onto` intuitive and safe. Available as both a **standalone git subcommand** and a **Zsh plugin**, it uses `fzf` to provide a visual, step-by-step workflow for rebasing commit ranges between branches.

**Perfect for managing stacked pull requests, feature branches, and complex git workflows.**

## 🚀 Why Use grob?

**Git rebase onto** (`git rebase --onto <target> <upstream> <branch>`) is powerful but difficult to visualize and error-prone. **grob simplifies git rebasing** by:

- 🎯 **Visual branch selection** with fuzzy finding
- 📊 **Live commit previews** showing diffs, stats, and metadata
- ✅ **Safety checks** preventing rebases with uncommitted changes
- 🔄 **Perfect for stacked PRs** and feature branch workflows
- 🚀 **Fast and efficient** - no need to memorize complex `HEAD~N` syntax

## Demo 🎥

https://github.com/user-attachments/assets/3ec937d2-7e9b-4ff8-bbb7-7541bbb1e21b


### The Killer Use Case: Managing Stacked Pull Requests

If you work with **stacked pull requests** (Branch B based on Branch A, which is based on `main`), you often face this scenario:
- Branch A gets updated, amended, or squashed
- Branch B still references the old version of Branch A
- You need to move Branch B onto the new Branch A without ghost commits

This requires `git rebase --onto`, which is complex to construct manually.

**grob makes stacked PR management effortless:**
1. 🎯 Select the updated Branch A (target)
2. 📍 Select the first commit unique to Branch B (base)
3. ✅ Review and confirm the rebase operation

No more calculating commit hashes or `HEAD~N` references manually!

---

## 🛠 Features

* **🔍 Interactive Branch Selection:** Fuzzy find branches with `fzf` and preview git history
* **📊 Rich Commit Previews:** View commit messages, authors, dates, file stats, and full diffs
* **🛡️ Safety First:** Dirty worktree check prevents rebasing with uncommitted changes
* **🌍 Cross-Platform:** Works on macOS (BSD tools) and Linux (GNU tools)
* **🎨 Clean Terminal UI:** Formatted summary cards with proper alignment
* **⚙️ Git Flag Passthrough:** Full support for `git rebase` flags (`-i`, `--autosquash`, `-Xours`, etc.)
* **📦 Multiple Install Options:** Homebrew, manual install, or Oh-My-Zsh plugin
* **⚡ Fast Workflow:** No need to look up commit SHAs or calculate `HEAD~N` offsets

---

## 📦 Installation

Choose your preferred installation method:

### Option 1: Homebrew (Recommended for macOS/Linux)

Install as a **git subcommand** - works seamlessly with your existing git workflow:

```bash
brew tap sspathak/tap
brew install git-grob
```

Then invoke with git:
```bash
git grob              # Run the interactive rebase tool
git grob -i           # With interactive mode
git grob --autosquash # With autosquash enabled
```

### Option 2: Manual Installation (Any Unix-like System)

Install the standalone executable:

```bash
# Download and install
curl -o /usr/local/bin/git-grob https://raw.githubusercontent.com/sspathak/zsh-grob/main/git-grob
chmod +x /usr/local/bin/git-grob

# Use it as a git subcommand
git grob
```

**Requirements:** Zsh must be available at `/usr/bin/env zsh`

### Option 3: Oh-My-Zsh Plugin

Install as a **Zsh plugin** for a shorter command (`grob` instead of `git grob`):

```bash
# Clone into Oh-My-Zsh custom plugins
git clone https://github.com/sspathak/zsh-grob ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/grob
```

Then enable in your `~/.zshrc`:
```zsh
plugins=(git fzf grob)  # Add 'grob' to your plugins array
```

Reload your shell:
```bash
source ~/.zshrc
```

Now invoke with the shorter command:
```bash
grob              # Same functionality as 'git grob'
grob -i           # With interactive mode
grob --autosquash # With autosquash enabled
```

---

## 📖 Usage

### Basic Usage

Run the interactive rebase tool:
```bash
git grob              # If installed via Homebrew or manual install
grob                  # If installed as Oh-My-Zsh plugin
```

### Advanced Usage with Git Flags

Pass any `git rebase` flags to customize behavior:
```bash
git grob -i            # Interactive rebase mode (edit, squash, reword commits)
git grob --autosquash  # Auto-squash commits marked with fixup!/squash!
git grob -Xours        # Use "ours" merge strategy for conflicts
git grob -i --autosquash  # Combine multiple flags
```

All unrecognized flags are passed directly to the underlying `git rebase --onto` command.

### Interactive Workflow

#### Step 1: Select Target Branch
Use `fzf` fuzzy finder to select the **destination branch** where commits should land.
- ⬆️⬇️ Navigate with arrow keys
- 🔍 Type to filter branches
- 📜 Preview window shows branch history
- ↵ Press Enter to select

#### Step 2: Select Base Commit
Select the **oldest commit** to move (inclusive selection).
- All commits from this one to `HEAD` will be rebased
- Preview shows commit details: author, date, stats, and full diff
- Color-coded file changes help identify the right commit

#### Step 3: Review and Confirm
A summary card displays:
```
┌─────────────────────────────────────────────┐
│ Target Branch:  feature-branch-a            │
│ Commit Count:   5                           │
│ Starting At:    abc123f                     │
│ Extra Flags:    -i --autosquash             │
│ Command:        git rebase --onto ...       │
└─────────────────────────────────────────────┘
```

- Press **`y`** to execute the rebase
- Press **`n`** to abort safely

### Example: Rebasing Stacked PRs

```bash
# Scenario: Branch B is based on old version of Branch A
# Branch A has been updated, need to rebase Branch B

git checkout branch-b
git grob

# Step 1: Select 'branch-a' (the updated target)
# Step 2: Select first commit unique to branch-b
# Step 3: Review and confirm with 'y'

# Result: branch-b now cleanly based on updated branch-a
```

## ⚠️ Requirements

- **Zsh** - The script is written in Zsh
- **fzf** - Required for interactive fuzzy finding ([installation guide](https://github.com/junegunn/fzf#installation))
- **Git** - Version 1.7.0+ (for `git rebase --onto` support)

## 🤝 Contributing

Contributions welcome! This project helps developers manage complex git workflows more easily.

**Repository:** [github.com/sspathak/zsh-grob](https://github.com/sspathak/zsh-grob)

## 📄 License

MIT License

## 🏷️ Keywords

git rebase tool, interactive git rebase, git rebase onto, stacked pull requests, stacked PRs, git workflow, feature branch management, git subcommand, zsh plugin, fzf git, git automation, rebase helper, git cli tool
