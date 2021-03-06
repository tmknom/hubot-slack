# Description:
#   An HTTP Listener that notifies about new Github issues comment
#
# URLS:
#   POST /hubot/github/hook-issue-comment?room=12345678

COMMAND_NAME = "hook-issue-comment"
githubHookLogger = require('../modules/github-hook-logger')(COMMAND_NAME)
slackMessenger = require('../modules/slack-messenger')()

module.exports = (robot) ->
  robot.router.post "/hubot/github/hook-issue-comment", (req, res) ->
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
    if data.action == 'created'
      cb createCreatedMessage(data)


  # Issueのコメントが作成された時のメッセージ
  createCreatedMessage = (data) ->
    body = "\n```#{data.comment.body}```"
    message = "#{data.comment.user.login} さんがコメントしたなっしー＞＜"
    return slackMessenger.createCommonMessage message, data.issue.title, data.issue.html_url, body
