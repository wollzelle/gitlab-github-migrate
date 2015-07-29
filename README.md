
# GitLab to GitHub migration

Migrate repositories, wikis, issues and milestones from GitLab to GitHub.

## Install

1. Set environment variables in `.env`
  * `GITLAB_URL` - The URL of your local GitLab instance e.g. `http://GitLab.local`
  * `GITLAB_GIT_URL` - The Git URL of your local GitLab instance e.g. `git@GitLab.local`
  * `GITLAB_TOKEN` - Your [GitLab API token](http://git.wz/profile/account)
  * `GITHUB_ORG` - Your GitHub organization name e.g. `wollzelle`
  * `GITHUB_TEAM_ID` - The id of the GitHub team that will be granted access to this repository
  * `GITHUB_USERNAME` - Your GitHub username e.g. `meleyal`
  * `GITHUB_TOKEN` - Your [GitHub API token](https://github.com/settings/tokens)

3. Install dependencies with `npm install`

4. List available tasks with `cake`

## Examples

    cake -i 6 -l websites/my-website -h my-website migrate:repo
    cake -i 6 -l websites/my-website -h my-website migrate:wiki
    cake -i 6 -l websites/my-website -h my-website migrate:issues
    cake -i 6 -l websites/my-website -h my-website migrate:milestones

## Notes

* `gitlab_id` can be found by inspecting the `body` tag of the GitLab project page (e.g. `data-project-id="84"`), or via the GitLab API.

* `GITHUB_TEAM_ID` can be found via `api.github.com/teams` (requires org owner rights).

* `migrate:wiki` requires that the GitHub wiki must be created first (it's enough to create a single blank page).
