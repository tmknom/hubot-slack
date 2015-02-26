# Description:
#   An HTTP Listener that notifies about new Github pull requests
#
# URLS:
#   POST /hubot/github/hook-pull-request?room=12345678

COMMAND_NAME = "hook-pull-request"
githubHookLogger = require('../modules/github-hook-logger')(COMMAND_NAME)
slackMessenger = require('../modules/slack-messenger')()

module.exports = (robot) ->
  robot.router.post "/hubot/github/hook-pull-request", (req, res) ->
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
    action = data.action
    if action == 'opened'
      cb createOpenedMessage(data)
    if action == 'assigned'
      cb createAssignedMessage(data)
    if action == 'closed' and data.pull_request.merged
      cb createMergedMessage(data)


  # プルリクエストが出た時のメッセージ
  createOpenedMessage = (data) ->
    if data.pull_request.body
      body = "\n```#{data.pull_request.body}```"
    else
      body = ""

    message = "#{data.pull_request.user.login} さんがプルリクを出したなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.pull_request.title, data.pull_request.html_url, body


  # プルリクエストのレビューアがアサインされた時のメッセージ
  createAssignedMessage = (data) ->
    message = "#{data.pull_request.assignee.login}さんにコードレビューがアサインされたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.pull_request.title, data.pull_request.html_url


  # プルリクエストがマージされた時のメッセージ
  createMergedMessage = (data) ->
    message = "ヒャッハー！ #{data.pull_request.merged_by.login} さんがコードをマージしてくれたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.pull_request.title, data.pull_request.html_url
