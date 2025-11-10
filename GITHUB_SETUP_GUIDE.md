# 🚀 GitHub Setup Guide for MRAC-LLM

Complete guide for uploading and managing your project on GitHub.

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Initial GitHub Setup](#initial-github-setup)
- [Upload Project to GitHub](#upload-project-to-github)
- [Repository Settings](#repository-settings)
- [Maintenance Commands](#maintenance-commands)
- [Best Practices](#best-practices)

---

## ✅ Prerequisites

### 1. Install Git

**Windows:**
- Download from: https://git-scm.com/download/win
- Run installer with default options
- Verify: `git --version`

**macOS:**
```bash
# Using Homebrew
brew install git

# Or download from: https://git-scm.com/download/mac
```

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install git

# Fedora
sudo dnf install git
```

### 2. Create GitHub Account

1. Go to: https://github.com
2. Click **Sign up**
3. Follow registration process
4. Verify your email

### 3. Configure Git

```bash
# Set your name
git config --global user.name "Your Name"

# Set your email (use GitHub email)
git config --global user.email "your.email@example.com"

# Verify settings
git config --list
```

---

## 🎯 Initial GitHub Setup

### Step 1: Create New Repository on GitHub

1. Go to: https://github.com/new
2. Fill in repository details:
   - **Repository name**: `MRAC_LLM`
   - **Description**: `GPT-Powered Model Reference Adaptive Control System`
   - **Visibility**: Choose Public or Private
   - **Do NOT initialize** with README, .gitignore, or license (we have them)
3. Click **Create repository**

### Step 2: Copy Repository URL

After creation, you'll see:
```
https://github.com/YOUR_USERNAME/MRAC_LLM.git
```

Copy this URL for next steps.

---

## 📤 Upload Project to GitHub

### Method 1: Command Line (Recommended)

Open terminal/command prompt in your `MRAC_LLM` folder:

```bash
# 1. Initialize Git repository (if not already done)
git init

# 2. Add all files to staging
git add .

# 3. Create initial commit
git commit -m "Initial commit: MRAC-LLM project with GPT integration"

# 4. Rename branch to main (if needed)
git branch -M main

# 5. Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/MRAC_LLM.git

# 6. Push to GitHub
git push -u origin main
```

**If you get authentication error:**
```bash
# Use Personal Access Token instead of password
# Create token at: https://github.com/settings/tokens

# Or use SSH (recommended for frequent use)
ssh-keygen -t ed25519 -C "your.email@example.com"
# Follow prompts, then add key to GitHub:
# https://github.com/settings/keys
```

### Method 2: GitHub Desktop (Easier for Beginners)

1. Download GitHub Desktop: https://desktop.github.com/
2. Install and sign in with GitHub account
3. Click **File** → **Add Local Repository**
4. Select your `MRAC_LLM` folder
5. Click **Publish repository**
6. Choose visibility and click **Publish**

---

## ⚙️ Repository Settings

### Step 1: Add Repository Description

1. Go to your repository: `https://github.com/YOUR_USERNAME/MRAC_LLM`
2. Click **Settings** (gear icon)
3. Add description and website (if any)
4. Add topics/tags:
   - `matlab`
   - `simulink`
   - `control-systems`
   - `adaptive-control`
   - `gpt-4`
   - `mrac`
   - `ai-powered`

### Step 2: Enable Features

In **Settings** → **General**:

- ✅ **Issues**: Enable for bug tracking
- ✅ **Discussions**: Enable for Q&A
- ✅ **Projects**: Enable for roadmap
- ✅ **Wiki**: Enable for extended docs

### Step 3: Set Branch Protection

In **Settings** → **Branches**:

1. Click **Add branch protection rule**
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date

### Step 4: Add Topics and About Section

1. Click **⚙️ Settings** next to About
2. Add description:
   ```
   GPT-Powered Model Reference Adaptive Control System with MATLAB/Simulink integration
   ```
3. Add website (if any)
4. Add topics (see Step 1)

---

## 🔄 Maintenance Commands

### Daily Workflow

```bash
# 1. Check status
git status

# 2. See what changed
git diff

# 3. Add changes
git add .
# Or add specific files:
git add MRACApp.m api/callGptApi_combined.m

# 4. Commit with message
git commit -m "Fix: Improved GPT response parsing"

# 5. Push to GitHub
git push origin main
```

### Working with Branches

```bash
# Create and switch to new branch
git checkout -b feature/new-mrac-variant

# Make changes, then commit
git add .
git commit -m "Add new MRAC variant"

# Push branch to GitHub
git push origin feature/new-mrac-variant

# Switch back to main
git checkout main

# Merge branch (after PR approval)
git merge feature/new-mrac-variant

# Delete branch
git branch -d feature/new-mrac-variant
```

### Syncing with Remote

```bash
# Fetch changes from GitHub
git fetch origin

# Pull changes (fetch + merge)
git pull origin main

# Force pull (careful!)
git fetch origin
git reset --hard origin/main
```

### Viewing History

```bash
# View commit history
git log

# View compact history
git log --oneline --graph

# View changes in commit
git show <commit-hash>

# View file history
git log -- MRACApp.m
```

### Undoing Changes

```bash
# Discard changes in file
git checkout -- filename.m

# Unstage file
git reset HEAD filename.m

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert commit (creates new commit)
git revert <commit-hash>
```

---

## 📦 Common Tasks

### Update README

```bash
# Edit README.md
# Then:
git add README.md
git commit -m "Update README with new features"
git push origin main
```

### Add New Files

```bash
# Create new file
# Then:
git add new_file.m
git commit -m "Add new MRAC algorithm"
git push origin main
```

### Ignore Files

Edit `.gitignore`:
```bash
# Add patterns
echo "*.asv" >> .gitignore
echo "temp_*.mat" >> .gitignore

git add .gitignore
git commit -m "Update gitignore"
git push origin main
```

### Create Release

1. Go to: `https://github.com/YOUR_USERNAME/MRAC_LLM/releases`
2. Click **Create a new release**
3. Fill in:
   - **Tag version**: `v1.0.0`
   - **Release title**: `MRAC-LLM v1.0.0 - Initial Release`
   - **Description**: List of features and changes
4. Attach binaries (if any)
5. Click **Publish release**

---

## 🏷️ Git Best Practices

### Commit Messages

**Good:**
```bash
git commit -m "Add filtered MRAC implementation"
git commit -m "Fix: Correct GPT API error handling"
git commit -m "Update: Improve GUI responsiveness"
git commit -m "Docs: Add installation guide"
```

**Bad:**
```bash
git commit -m "update"
git commit -m "fix bug"
git commit -m "changes"
git commit -m "asdf"
```

**Format:**
```
<type>: <description>

Types:
- Add: New feature
- Fix: Bug fix
- Update: Improve existing feature
- Docs: Documentation changes
- Test: Add or update tests
- Refactor: Code restructuring
- Style: Formatting changes
```

### Commit Frequency

- ✅ Commit after completing a logical unit of work
- ✅ Commit before switching branches
- ✅ Commit at end of day
- ❌ Don't commit broken code to main
- ❌ Don't commit giant changes (break into smaller commits)

### Branch Strategy

```
main (production-ready code)
  ├── develop (integration branch)
  │     ├── feature/new-algorithm
  │     ├── feature/ui-improvements
  │     └── fix/api-bug
  └── hotfix/critical-bug
```

### File Organization

```
✅ Keep repository clean
✅ Use .gitignore effectively
✅ Don't commit large binary files
✅ Don't commit sensitive data (API keys)
✅ Don't commit generated files
```

---

## 🔒 Security Best Practices

### Protect Sensitive Data

```bash
# Already added to .gitignore:
config.json          # Contains API keys
*.key
.env

# If accidentally committed:
git rm --cached config.json
git commit -m "Remove sensitive config"
git push origin main

# Then use git filter-branch or BFG to remove from history
```

### Use Environment Variables

```bash
# Instead of hardcoding API keys
# Use environment variables or config files

# .env (add to .gitignore)
OPENAI_API_KEY=sk-proj-...

# config.json.example (commit this)
{
  "apiKey": "your-key-here",
  "model": "gpt-4o"
}
```

---

## 🎯 Quick Reference

### Essential Commands

| Command | Description |
|---------|-------------|
| `git status` | Check repository status |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit with message |
| `git push origin main` | Push to GitHub |
| `git pull origin main` | Pull from GitHub |
| `git branch` | List branches |
| `git checkout -b name` | Create new branch |
| `git log` | View commit history |
| `git diff` | Show changes |
| `git reset --hard` | Discard all changes |

### GitHub URLs

| Page | URL |
|------|-----|
| Your repository | `https://github.com/YOUR_USERNAME/MRAC_LLM` |
| Issues | `https://github.com/YOUR_USERNAME/MRAC_LLM/issues` |
| Pull requests | `https://github.com/YOUR_USERNAME/MRAC_LLM/pulls` |
| Settings | `https://github.com/YOUR_USERNAME/MRAC_LLM/settings` |
| Releases | `https://github.com/YOUR_USERNAME/MRAC_LLM/releases` |

---

## 🆘 Troubleshooting

### Problem: Authentication Failed

```bash
# Solution 1: Use Personal Access Token
# Create at: https://github.com/settings/tokens
# Use token instead of password

# Solution 2: Use SSH
ssh-keygen -t ed25519 -C "your.email@example.com"
# Add key to GitHub: https://github.com/settings/keys
git remote set-url origin git@github.com:YOUR_USERNAME/MRAC_LLM.git
```

### Problem: Merge Conflicts

```bash
# 1. Pull latest changes
git pull origin main

# 2. Resolve conflicts in files (edit manually)
# Git marks conflicts like:
# <<<<<<< HEAD
# Your changes
# =======
# Their changes
# >>>>>>> branch

# 3. After fixing:
git add .
git commit -m "Resolve merge conflicts"
git push origin main
```

### Problem: Accidentally Committed Large File

```bash
# Remove from latest commit
git rm --cached large_file.mat
git commit --amend -m "Remove large file"
git push origin main --force

# Remove from history (use BFG)
# Download from: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files large_file.mat
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

---

## 🎉 Next Steps

After uploading to GitHub:

1. ✅ **Add README badges** for better visibility
2. ✅ **Enable GitHub Pages** for documentation
3. ✅ **Set up GitHub Actions** for CI/CD
4. ✅ **Create project board** for task tracking
5. ✅ **Add contributors** if working with team
6. ✅ **Star your own repo** (why not! 😄)
7. ✅ **Share with community** on MATLAB Central, Reddit, Twitter

---

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Pro Git Book](https://git-scm.com/book/en/v2) (Free)

---

<div align="center">

**Your MRAC-LLM project is now on GitHub! 🎉**

[⬆ Back to README](README.md)

</div>

