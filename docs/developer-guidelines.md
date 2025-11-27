# Developer Guidelines

This document outlines the development workflow and best practices for contributing to the k8s-with-kops project.

## Workflow Overview

All development must follow a structured workflow to maintain code quality, traceability, and prevent conflicts in the main branch.

## Step-by-Step Development Process

### 1. Create an Issue

Before starting any work, create an issue to track the task:

- Go to the repository's **Issues** section
- Click **New Issue**
- Provide a descriptive title and detailed description of the work
- Add relevant labels (e.g., `feature`, `bug`, `documentation`, `enhancement`)
- Add milestone if applicable
- Click **Submit new issue**

**Note**: Every pull request should be linked to an issue for traceability.

### 2. Assign the Issue to Yourself

- Open the issue you created
- Click on **Assignees** on the right panel
- Select yourself from the list
- This prevents duplicate work and shows you're actively working on it

### 3. Create a Feature Branch

Never work directly on the `main` branch. Always create a feature branch:

```bash
# Update main branch to latest
git checkout main
git pull origin main

# Create a new feature branch with a descriptive name
git checkout -b feature/issue-#<issue-number>-<short-description>
```

**Branch Naming Convention**:

- For features: `feature/issue-#123-add-vpc-module`
- For bug fixes: `bugfix/issue-#456-fix-iam-policy`
- For documentation: `docs/issue-#789-update-readme`
- For hotfixes: `hotfix/issue-#999-critical-security-patch`

### 4. Make Your Changes

- Work on your feature branch
- Write clean, well-documented code
- Follow the project's coding standards
- Commit regularly with clear commit messages

**Commit Message Format**:

```text
<type>: <subject> (#<issue-number>)

<body>

<footer>
```

Example:

```text
feat: add VPC module for AWS infrastructure (#123)

- Created vpc/main.tf with security group configurations
- Added subnet configuration for public and private networks
- Updated variables.tf with VPC parameters

Closes #123
```

### 5. Push to Your Feature Branch

```bash
git push origin feature/issue-#<issue-number>-<short-description>
```

### 6. Create a Pull Request (PR)

- Go to the repository on GitHub
- Click **New Pull Request**
- Select your feature branch as the source and `main` as the destination
- Fill in the PR template with:
  - Clear description of changes
  - Reference to the issue (use `Closes #<issue-number>`)
  - Any relevant testing information
  - Screenshots or examples if applicable
- Request reviewers
- Click **Create Pull Request**

**PR Template Example**:

```markdown
## Description
Briefly describe what this PR does.

## Issue
Closes #<issue-number>

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
How has this been tested?

## Screenshots (if applicable)
```

### 7. Code Review Process

- Request at least one reviewer
- Address review comments and make requested changes
- Push additional commits to the same branch
- Once approved, the PR can be merged

### 8. Merge to Main Branch

Only merge when:

- PR has at least one approval
- All CI/CD checks pass
- Branch is up to date with `main`
- All conversations are resolved

**Merge Options**:

- Use "Squash and merge" for feature branches (keeps history clean)
- Use "Create a merge commit" if the branch has multiple logical commits

## Important Rules

### Never Do This

1. **Never push directly to `main` branch**
   - All changes must go through a PR
   - Direct pushes bypass code review

2. **Never commit to main locally and push**
   - Create a branch and PR instead

3. **Never skip issue creation**
   - Every change should be tracked in an issue

4. **Never force push to shared branches**
   - Use `git push` (not `git push --force`)

### Always Do This

1. Create and assign an issue first
2. Create a feature branch from latest `main`
3. Make changes on your feature branch
4. Push to your feature branch (not main)
5. Create a PR with issue reference
6. Wait for approval and code review
7. Merge only after approval

## Branch Protection Rules

The `main` branch has protection enabled:

- Require pull request reviews before merging
- Require status checks to pass before merging
- Dismiss stale pull request approvals when new commits are pushed
- Require branches to be up to date before merging
- Include administrators (enforced for everyone)

## Useful Git Commands

```bash
# View all branches
git branch -a

# Update your branch with latest main
git fetch origin
git rebase origin/main

# View commit history
git log --oneline -10

# View changes
git diff main..your-branch

# Undo last commit (before pushing)
git reset --soft HEAD~1

# Stash changes temporarily
git stash
git stash pop
```

## Questions or Issues

If you have questions about the workflow or encounter issues:

- Open a GitHub issue
- Check existing documentation
- Reach out to the maintainers

---

**Last Updated**: November 27, 2025
