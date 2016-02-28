## Setup

1. Login to GitHub and view your [personal access tokens](https://github.com/settings/tokens)

2. Follow [these instructions](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) to create a new token with the default permissions

3. Copy the access token hex and set `GITHUB_ACCESS_TOKEN` to this value in `.env`

## Usage

```
$ ruby list-activity.rb <repo-owner>/<repo-name> <username> <start-date> <end-date>
```
