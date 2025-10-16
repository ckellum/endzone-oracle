# Using Git in Cursor - Complete Visual Guide

Your project is now fully set up with GitHub! This guide shows you how to use Cursor's built-in Git features to commit and push changes directly from the app.

---

## ✅ Your Setup is Complete!

- ✅ Git repository initialized
- ✅ Connected to GitHub: https://github.com/ckellum/endzone-oracle
- ✅ Authentication configured
- ✅ Initial code pushed
- ✅ Ready to use Cursor's Git interface!

---

## 🎯 Daily Workflow: Making Changes and Pushing to GitHub

### Step 1: Make Your Code Changes

Edit your Swift files, add features, fix bugs - work normally in Cursor!

---

### Step 2: Open Source Control Panel

**Three ways to open it:**

1. **Click the Source Control icon** in the left sidebar (looks like a branch with 3 circles)
2. Press **Cmd + Shift + G** (keyboard shortcut)
3. Go to **View → Source Control** from the menu

You'll see the Source Control panel open on the left side.

---

### Step 3: Review Your Changes

In the Source Control panel, you'll see:

**CHANGES** section - Shows all modified files:
- **M** = Modified (file was changed)
- **U** = Untracked (new file)
- **D** = Deleted (file was removed)
- **R** = Renamed (file was renamed)

**Click on any file** to see what changed:
- **Red lines** = deleted code
- **Green lines** = added code
- Side-by-side comparison shows before/after

---

### Step 4: Stage Your Changes

Before committing, you need to "stage" files (tell Git which changes to include):

**To stage individual files:**
- Hover over a file in the CHANGES section
- Click the **"+"** icon that appears

**To stage ALL files at once:**
- Click the **"+"** icon next to "Changes" header
- This stages everything (most common approach)

**Staged files** move to a "STAGED CHANGES" section at the top.

**To unstage a file:**
- Click the **"−"** icon next to a staged file

---

### Step 5: Commit Your Changes

Once files are staged:

1. **Click in the message box** at the top of Source Control panel
   - It says "Message (Cmd+Enter to commit)"

2. **Type your commit message:**
   - First line: Short summary (50 chars or less)
   - Examples:
     - "Fix crash when viewing game details"
     - "Add new statistics chart feature"
     - "Update team logos"
     - "Improve performance on Stats tab"

3. **Press Cmd + Enter** to commit
   - Or click the **✓ checkmark** button above the message box

4. Your changes are now **committed locally** (saved to your computer's Git history)

---

### Step 6: Push to GitHub

After committing, your changes are saved locally but NOT yet on GitHub.

**To push to GitHub:**

**Option A: Use the Sync Button (Easiest)**
- Look at the **status bar** at the bottom of Cursor
- Find the **sync icon** (↻ circular arrows) with a number
- Click it once
- Your changes upload to GitHub!

**Option B: Use the Menu**
- In Source Control panel, click the **"..."** menu (three dots)
- Click **"Push"**
- Your changes upload to GitHub!

**Option C: Keyboard Shortcut**
- After committing, you can push with a command
- Open Command Palette (Cmd + Shift + P)
- Type "Git: Push"
- Press Enter

---

### Step 7: Verify on GitHub

Go to: https://github.com/ckellum/endzone-oracle

- You should see your latest commit message
- Click on "commits" to see your full history
- Your code is now backed up and version-controlled!

---

## 🔄 Pulling Changes from GitHub

If you work on another computer or make changes directly on GitHub.com:

**To pull latest changes:**

1. Open Source Control panel (Cmd + Shift + G)
2. Click the **"..."** menu
3. Click **"Pull"**
4. Latest changes download to your computer

**Or:**
- Click the **sync icon** in the status bar (it will show a down arrow if there are changes to pull)

---

## 📸 Visual Reference: Where Everything Is

### Source Control Panel Layout:

```
┌─────────────────────────────────────┐
│ SOURCE CONTROL                      │
├─────────────────────────────────────┤
│                                     │
│ [Message box - type commit here]   │ ← Type your commit message
│ ✓ Commit    ... More Actions       │ ← Commit button & menu
│                                     │
├─────────────────────────────────────┤
│ STAGED CHANGES              +       │ ← Files ready to commit
│   M  MyFile.swift           -       │
│                                     │
├─────────────────────────────────────┤
│ CHANGES                     +       │ ← Modified files (not staged yet)
│   M  AnotherFile.swift      +       │ ← Click + to stage
│   U  NewFile.swift          +       │
│                                     │
└─────────────────────────────────────┘
```

### Bottom Status Bar:

```
┌────────────────────────────────────────────────────────────┐
│ main ✓  ↻ 0↓ 0↑  [Other status items...]                 │
│  ↑         ↑                                              │
│  │         └─ Sync button (click to push/pull)           │
│  └─ Current branch (main)                                │
└────────────────────────────────────────────────────────────┘
```

---

## 🎓 Common Workflows

### Workflow 1: Quick Save & Push (Most Common)

```
1. Make changes to your code
2. Cmd + Shift + G (open Source Control)
3. Click + next to "Changes" (stage all)
4. Type commit message
5. Cmd + Enter (commit)
6. Click sync button ↻ (push)
Done!
```

**Time:** ~10 seconds

---

### Workflow 2: Selective Staging (Advanced)

```
1. Make changes to multiple files
2. Cmd + Shift + G
3. Click + only on specific files you want to commit
4. Type commit message
5. Cmd + Enter
6. Click sync button
Done!
```

Use this when you want to commit some changes but not others.

---

### Workflow 3: Review Before Committing

```
1. Make changes
2. Cmd + Shift + G
3. Click on each changed file to review
4. Make sure changes look correct
5. Stage files with +
6. Commit and push
Done!
```

Good practice before pushing important changes!

---

## 💡 Pro Tips

### Tip 1: Commit Often
- Commit after completing a feature
- Commit after fixing a bug
- Commit before trying something experimental
- "Save points" in your code!

### Tip 2: Write Good Commit Messages

**Good messages:**
- ✅ "Fix crash when loading predictions"
- ✅ "Add Kalshi odds to game detail view"
- ✅ "Update 49ers logo to 2024 version"
- ✅ "Improve performance of stats calculations"

**Bad messages:**
- ❌ "fix"
- ❌ "changes"
- ❌ "asdf"
- ❌ "updates"

### Tip 3: Push Regularly
- Push at the end of each work session
- Push before closing your laptop
- Push before switching computers
- Your code is backed up on GitHub!

### Tip 4: Check the Sync Icon
- The number shows how many commits to push/pull
- ↑ 3 = 3 commits to push
- ↓ 2 = 2 commits to pull
- Keep it at 0 by syncing regularly!

### Tip 5: Use the Diff View
- Click on changed files to see what changed
- Review before committing
- Catch accidental changes
- See red (deleted) and green (added) lines

---

## 🚨 Troubleshooting

### "No changes detected"
- Make sure you saved your files (Cmd + S)
- Check if you're in the right project folder

### "Authentication failed"
- Your GitHub credentials expired
- Run `gh auth login` in terminal to re-authenticate
- Or use GitHub Desktop

### "Push rejected"
- Someone else pushed changes
- Click "Pull" first to get latest changes
- Then push again

### "Merge conflict"
- Rare if you're the only developer
- Cursor will show conflict markers
- Edit the file to resolve
- Commit the resolution

### Sync button is greyed out
- No commits to push yet
- Make sure you committed (not just staged)
- Check you're on the right branch

---

## 🎬 Quick Command Reference

**Keyboard Shortcuts:**
- **Cmd + Shift + G** - Open Source Control
- **Cmd + Enter** - Commit (when in message box)
- **Cmd + K, Cmd + P** - Git: Push
- **Cmd + K, Cmd + F** - Git: Pull

**Common Git Commands (if you prefer terminal):**
```bash
git status              # See what changed
git add .               # Stage all changes
git commit -m "message" # Commit with message
git push                # Push to GitHub
git pull                # Pull from GitHub
git log --oneline       # View commit history
```

---

## 📋 Workflow Checklist

Use this checklist for each work session:

**Starting Work:**
- [ ] Open Cursor
- [ ] Pull latest changes (click sync ↻)
- [ ] Start coding!

**During Work:**
- [ ] Save files frequently (Cmd + S)
- [ ] Commit logical chunks of work
- [ ] Write clear commit messages

**Ending Work:**
- [ ] Review all changes in Source Control
- [ ] Stage and commit remaining changes
- [ ] Push to GitHub (click sync ↻)
- [ ] Verify push succeeded (sync icon shows 0)
- [ ] Check GitHub.com to confirm

---

## 🎉 You're All Set!

Your Cursor is now fully integrated with GitHub. You can:
- ✅ Make changes visually in Cursor
- ✅ Commit with one click
- ✅ Push to GitHub automatically
- ✅ Pull changes when needed
- ✅ View change history
- ✅ Never lose work again!

---

## 📚 Additional Resources

**Cursor Documentation:**
- https://docs.cursor.com/

**Git Basics:**
- https://git-scm.com/book/en/v2/Getting-Started-Git-Basics

**GitHub Docs:**
- https://docs.github.com/en/get-started

**Your Repository:**
- https://github.com/ckellum/endzone-oracle

---

## 💬 Need Help?

If you run into issues:
1. Check the troubleshooting section above
2. Look at the error message in Source Control panel
3. Ask me for help with the specific error
4. Check GitHub's status page: https://www.githubstatus.com/

---

**Happy coding! Your work is now safely backed up on GitHub.** 🚀
