## GitHub CLI (`gh`) Commands

### Auth
```bash
gh auth login                     # authenticate (browser, token, or SSH)
gh auth status                    # check who you're logged in as
gh auth switch                    # switch between multiple accounts
gh auth logout                    # log out
```

### Repositories
```bash
gh repo create <name> --public --add-readme   # create new repo
gh repo clone <owner>/<repo>                  # clone via gh
gh repo view <owner>/<repo>                   # view repo details
gh repo view <owner>/<repo> --web             # open repo in browser
gh repo list <owner>                          # list repos
gh repo delete <owner>/<repo> --yes           # delete repo (careful!)
gh browse                                     # open current repo in browser
```

### Issues
```bash
gh issue create --title "<title>" --body "<body>" --label "bug"
gh issue list                     # list open issues
gh issue list --state all         # list all issues (open + closed)
gh issue view <number>            # view a specific issue
gh issue close <number>           # close an issue
gh issue reopen <number>          # reopen an issue
```

### Pull Requests
```bash
gh pr create --fill               # create PR, auto-fill from commits
gh pr create --title "<t>" --body "<b>" --base main
gh pr list                        # list open PRs
gh pr view <number>               # view PR details
gh pr checks <number>             # view CI check status for a PR
gh pr checkout <number>           # check out a PR branch locally
gh pr diff <number>               # view PR diff
gh pr review <number> --approve --body "LGTM"
gh pr review <number> --request-changes --body "..."
gh pr merge <number> --squash --delete-branch   # merge methods: --merge / --squash / --rebase
```

### Actions / Workflows
```bash
gh run list                       # list workflow runs
gh run view <run-id>              # view a run's status
gh run view <run-id> --log        # view full run logs
gh run watch <run-id>             # block until a run finishes
gh workflow list                  # list workflows in the repo
gh workflow run <workflow-name>   # manually trigger a workflow
```

### Extras
```bash
gh api /user                      # raw GitHub REST API call
gh api graphql -f query='{ viewer { login } }'   # raw GraphQL call
gh gist create <file> --public    # create a gist
gh release create v1.0.0 --title "v1.0.0" --notes "..."
gh alias set prc 'pr create --fill'   # create your own shortcut aliases
gh search repos "<query>" --language go --stars ">100"
```

### Handy global flags
```bash
--repo owner/repo     # target a specific repo without cd-ing into it
--json <fields>        # machine-readable output for scripting (pair with jq)
--web                  # open the equivalent page in your browser
gh help                # top-level help
gh <command> --help    # help for a specific command
```