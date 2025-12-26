# grob (Git Rebase Onto Branch)

`grob` is an interactive Zsh plugin designed to make `git rebase --onto` intuitive and safe. It uses `fzf` to simplify selection of ranges of commits to be moved onto other beanches. 

## 🚀 Why Use `grob`?

The standard `git rebase --onto <target> <upstream> <branch>` command is powerful but notoriously difficult to visualize. `grob` solves this by providing a step-by-step interactive workflow.

## Demo 🎥
https://github.com/user-attachments/assets/d13caf3e-5f8f-43fa-a48f-8b5303ecc74a



### The Killer Use Case: Stacked PRs
If you work with **Stacked Pull Requests** (e.g., Branch B is based on Branch A, which is based on `main`), you often run into a situation where Branch A is updated or squashed. To move Branch B to the new version of Branch A without dragging along "ghost" commits from the old version, you *must* use `rebase --onto`.



**`grob` makes this effortless:**
1. Select the new version of Branch A.
2. Select the first commit that belongs specifically to Branch B.
3. Review the summary and confirm.

---

## 🛠 Features
* **Dirty Check:** Prevents rebasing if you have uncommitted changes.
* **Interactive Selection:** Uses `fzf` to pick branches and commits.
* **High-Density Preview:** See commit messages, authors, dates, and file change summaries (`--stat`) live as you browse.
* **Cross-Platform Compatibility:** Works on both macOS (BSD) and Linux (GNU) environments.
* **Classic UI:** A clean, formatted summary "card" using a table layout for perfect alignment.
* **Flag Passthrough:** Supports standard flags like `-i`, `--autosquash`, or `-Xours`.

---

## 📦 Installation (Oh-My-Zsh)

1.  **Create the plugin directory:**
    ```bash
    mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/grob
    ```

2.  **Save the script:**
    Create a file named `grob.plugin.zsh` in that directory and paste the function code into it.

3.  **Enable the plugin:**
    Open your `~/.zshrc` and add `grob` to your plugins list:
    ```zsh
    plugins=(git fzf grob)
    ```

4.  **Reload your shell:**
    ```bash
    source ~/.zshrc
    ```

---

## 📖 How to Use

Simply type `grob` in your terminal. You can also pass optional flags that will be appended to the final command:

```bash
grob -i            # Opens the rebase in interactive mode after selection
grob --autosquash  # Enables autosquash
grob -Xours        # Uses the "ours" merge strategy
```

### Step 1: Select the Target
Pick the branch where you want the commits to land (the "destination"). A preview window will show you the recent history of the highlighted branch to help you confirm it's the right choice.

### Step 2: Select the Oldest Commit
Select the **oldest** commit you want to move. 
> **Note:** This selection is inclusive. This commit and every commit newer than it (up to your current HEAD) will be moved. The preview window here shows a high-density summary of the commit, including the author, date, and a colorized file change stat.

### Step 3: Review and Confirm
A summary card will appear showing:
* **Target Branch:** Where you are moving to.
* **Commit Count:** Exactly how many commits are in the stack.
* **Starting At:** The hash of the oldest commit you selected.
* **Extra Flags:** Any flags you passed (like `-i`).
* **Command:** The literal git command about to be run.

Press `y` to execute or `n` to abort.

## ⚠️ Requirements
* Zsh
* fzf: Required for the interactive UI.
* Git
