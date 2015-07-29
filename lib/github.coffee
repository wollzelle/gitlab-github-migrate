require('dotenv').load()
request = require 'request-promise'
requestJSON = request.defaults(headers: { 'User-Agent': "#{process.env.GITHUB_ORG}" }, json: true)

GitHub = module.exports =

  req: (method, path, data = {}) ->
    { GITHUB_ORG, GITHUB_USERNAME, GITHUB_TOKEN } = process.env
    url = "https://#{GITHUB_USERNAME}:#{GITHUB_TOKEN}@api.github.com/repos/#{GITHUB_ORG}/#{path}"
    requestJSON[method] url, { body: data }

  get: (path) ->
    GitHub.req 'get', path

  post: (path, data) ->
    GitHub.req 'post', path, data

  patch: (path, data) ->
    GitHub.req 'patch', path, data

  destroy: (path) ->
    GitHub.req 'del', path

  createRepo: (projectName) ->
    { GITHUB_ORG, GITHUB_USERNAME, GITHUB_TOKEN, GITHUB_TEAM_ID } = process.env
    url = "https://#{GITHUB_USERNAME}:#{GITHUB_TOKEN}@api.github.com/orgs/#{GITHUB_ORG}/repos"
    requestJSON.post url, { body: { name: projectName, private: true, team_id: GITHUB_TEAM_ID } }

  createIssue: (projectName, issue, comments) ->
    delete issue.milestone
    delete issue.assignee
    issue.state = 'open' if issue.state in ['opened', 'reopened']

    GitHub.post "#{projectName}/issues", issue
      .then (newIssue) ->
        if issue.state is 'closed'
          GitHub.patch "#{projectName}/issues/#{newIssue.number}", { state: 'closed' }
        for comment in comments
          GitHub.post "#{projectName}/issues/#{newIssue.number}/comments", comment

  createMilestone: (projectName, milestone) ->
    return if milestone.state is 'closed'
    milestone.state = 'open' if milestone.state is 'active'
    delete milestone.due_date
    GitHub.post "#{projectName}/milestones", milestone

  deleteMilestones: (projectName) ->
    GitHub.get "#{projectName}/milestones?state=all"
      .then (milestones) ->
        for milestone in milestones
          do (milestone) ->
            GitHub.destroy "#{projectName}/milestones/#{milestone.number}"
