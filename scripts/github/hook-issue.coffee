# Description:
#   An HTTP Listener that notifies about new Github issues
#
# URLS:
#   POST /hubot/github/hook-issue?room=12345678

COMMAND_NAME = "hook-issue"
githubHookLogger = require('../modules/github-hook-logger')(COMMAND_NAME)
slackMessenger = require('../modules/slack-messenger')()

module.exports = (robot) ->
  robot.router.post "/hubot/github/hook-issue", (req, res) ->
    githubHookLogger.startLog req

    room = slackMessenger.getRoom req
    try
      announceMessage req, (what) ->
        robot.messageRoom room, what
        githubHookLogger.completedLog req
    catch error
      robot.messageRoom room, COMMAND_NAME + "を実行しようとしてエラーったなっしー＞＜\n" + error
      githubHookLogger.failedLog error, req

    res.end "ok"


  # アクションに応じて、メッセージを出し分け
  announceMessage = (req, cb) ->
    data = req.body
    if data.action == 'opened'
      cb createOpenedMessage(data)
    if data.action == 'assigned'
      cb createAssignedMessage(data)
    if data.action == 'reopened'
      cb createReOpenedMessage(data)
    if data.action == 'closed'
      cb createClosedMessage(data)


  # Issueが発行された時のメッセージ
  createOpenedMessage = (data) ->
    if data.issue.body
      body = "\n```#{data.issue.body}```"
    else
      body = ""

    message = "#{data.issue.user.login} さんがIssueを出したなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.issue.title, data.issue.html_url, body


  # Issueがアサインされた時のメッセージ
  createAssignedMessage = (data) ->
    message = "#{data.issue.assignee.login}さんにIssueがアサインされたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.issue.title, data.issue.html_url


  # Issueが再オープンされた時のメッセージ
  createReOpenedMessage = (data) ->
    message = "#{data.issue.user.login} さんがIssueを再オープンしたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.issue.title, data.issue.html_url


  # Issueがクローズされた時のメッセージ
  createClosedMessage = (data) ->
    message = "ヒャッハー！ #{data.issue.user.login} さんがIssueをクローズしてくれたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.issue.title, data.issue.html_url
