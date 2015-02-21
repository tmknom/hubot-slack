# Description:
#   create new pull requests for Github
#
# Dependencies:
#   "githubot": "0.4.x"
#   "underscore": "1.8.1"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API
#
# Commands:
#   hubot pull-request <repo_name> <head> into <base> - create pull request
#

_ = require("underscore")

module.exports = (robot) ->
  robot.respond /pull-request ([-_\.0-9a-zA-Z]+) from ([-_\.a-zA-z0-9\/]+)? into ([-_\.a-zA-z0-9\/]+)?$/i, (msg)->
    github = require("githubot")(robot)

    repository = msg.match[1]
    head = msg.match[2]
    base = msg.match[3] || "master"

    accountName = msg.envelope.user.name

    data = {
      "title": createTitle accountName
      "body": createBody accountName
      "head": head
      "base": base
    }
    url = createApiUrl repository

    github.post url, data, (pull) ->
      msg.send "プルリク作りました！\n" + pull.html_url

    github.handleErrors (response) ->
      console.log response
      msg.send "プルリクエスト作成に失敗しました (´･ω･`)ｼｮﾎﾞｰﾝ\n" + JSON.parse(response.body).errors[0].message


createApiUrl = (repository) ->
  unless (github_api = process.env.HUBOT_GITHUB_API)?
    github_api = "https://api.github.com"

  unless (github_user = process.env.HUBOT_GITHUB_USER)?
    throw new Error('You must set HUBOT_GITHUB_USER in your environment variables');

  # https://developer.github.com/v3/pulls/#create-a-pull-request
  return "#{github_api}/repos/#{github_user}/#{repository}/pulls"


createTitle = (account_name) ->
  get_now = ->
    require('date-utils');
    return new Date().toFormat("YYYY/MM/DD/ HH24:MI:SS");

  return "#{get_now()} pull request by #{account_name}"


createBody = (account_name) ->
  messages = [
             """
              ・#{account_name}がHubotから作成しました
              ・コードレビューをお願いします
             """
             ]

  return _.sample(messages)
