require('dotenv').load()
require 'shelljs/global'
GitHub = require './github'

Git = module.exports =

  migrateRepo: (options) ->
    { gitlab_name, github_name } = options
    { GITLAB_GIT_URL, GITHUB_ORG } = process.env

    repo = "#{github_name}.git"
    gitlabRemote = "#{GITLAB_GIT_URL}:#{gitlab_name}.git"
    githubRemote = "git@github.com:#{GITHUB_ORG}/#{github_name}.git"

    rm "-rf", repo
    exec "git clone --mirror #{gitlabRemote}"
    cd repo
    exec "git remote add github #{githubRemote}"

    GitHub.createRepo(github_name)
      .then ->
        exec "git push github --mirror"
        rm '-rf', repo
      .catch (err) -> console.log err.error

  migrateWiki: (options) ->
    { gitlab_name, github_name } = options
    { GITLAB_GIT_URL, GITHUB_ORG } = process.env

    repo = "#{github_name}.git"
    gitlabRemote = "#{GITLAB_GIT_URL}:#{gitlab_name}.wiki.git"
    githubRemote = "git@github.com:#{GITHUB_ORG}/#{github_name}.wiki.git"

    rm "-rf", repo
    exec "git clone #{gitlabRemote} #{repo}"
    cd repo
    exec "git remote add github #{githubRemote}"
    exec "git push github --force"
    rm "-rf", repo
