require('dotenv').load()
request = require 'request-promise'
requestJSON = request.defaults(json: true)

GitLab = module.exports =
  get: (path) ->
    { GITLAB_URL, GITLAB_TOKEN } = process.env
    url = "#{GITLAB_URL}/api/v3/#{path}?private_token=#{GITLAB_TOKEN}&per_page=1000"
    requestJSON.get url

  getIssues: (projectId) ->
    GitLab.get "projects/#{projectId}/issues"

  getComments: (projectId, issueId) ->
    GitLab.get "projects/#{projectId}/issues/#{issueId}/notes"

  getMilestones: (projectId) ->
    GitLab.get "projects/#{projectId}/milestones"
