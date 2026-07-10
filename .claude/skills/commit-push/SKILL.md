---
name: commit-push
description: >-
  Stages changes, creates a commit following this repo's commit style, then
  asks for confirmation before pushing to the tracked remote branch. Use only
  when the user explicitly invokes /commit-push.
disable-model-invocation: true
---

# Commit and Push

Use this skill only when the user explicitly invokes `/commit-push`.

## Behavior

1. Run in parallel: `git status` (never `-uall`), `git diff` (staged + unstaged), and `git log --oneline -10` to learn this repo's commit message style.
2. If there is nothing to commit (no staged changes, no unstaged changes, no untracked files worth adding), say so and stop — do not create an empty commit.
3. Stage relevant files by name (not `git add -A`/`.`). If a broad add is genuinely appropriate, run `git status` afterward and check the file list — flag anything that looks like it could contain secrets (`.env`, credentials, keys) before proceeding, even if the filename looks innocuous.
4. Draft a concise (1-2 sentence) commit message focused on *why*, not *what*, matching the tone/format of recent commits from `git log`.
5. Create the commit with the message via a HEREDOC, ending with:
   ```
   Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
   ```
6. If a pre-commit hook fails, fix the underlying issue, re-stage, and create a **new** commit — never `--amend` a commit that didn't happen, and never skip hooks with `--no-verify` unless the user explicitly asks.
7. Run `git status` to confirm the commit succeeded.
8. **Before pushing**, show the user what will be pushed (`git log @{u}.. --oneline` if the branch has an upstream, or note that it has none) and ask for explicit confirmation. Do not push until they confirm.
9. On confirmation, run `git push` for the current branch (set upstream with `-u` only if none exists yet). Never force-push, never push to `main`/`master` with `--force`, and never push without the confirmation step above.
10. Report the commit hash/message and, if pushed, confirm the push succeeded (or report the failure).

## Notes

- Only commit files relevant to the task at hand — don't sweep in unrelated changes.
- This repo's convention (see `git log`): short, imperative or descriptive subject lines explaining the reason for the change, not a changelog of what was touched.
