# Description:
#   Logger of github hook script.

class GithubHookLogger

  constructor: (@commandName)->
    Log = require '../../node_modules/hubot/node_modules/log/lib/log'
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'


  startLog: (request) ->
    @logger.info new StartMessage(@commandName, request)


  completedLog: (request) ->
    @logger.info new CompletedMessage(@commandName, request)


  failedLog: (error, request) ->
    @logger.error new FailedMessage(@commandName, error, request)


class StartMessage
  constructor: (@commandName, request)->
    @event = "start"
    @action = request.body.action if request.body.action
    @originalUrl = request.originalUrl
    @query = request.query
    @requestId = request.headers['x-request-id']


class CompletedMessage
  constructor: (@commandName, request)->
    @event = "completed"
    @requestId = request.headers['x-request-id']


class FailedMessage
  constructor: (@commandName, error, request)->
    @event = "failed"
    @request = request.body
    @errorMessage = error
    @requestId = request.headers['x-request-id']


module.exports = (commandName) ->
  new GithubHookLogger commandName
