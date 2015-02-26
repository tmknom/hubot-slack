# Description:
#   Logger of github hook script.

class SlackMessenger

  # 投稿先の取得
  getRoom: (req) ->
    return req.query.room


  # 共通メッセージ作成
  createCommonMessage: (message, title, url, detail = "") ->
    return "#{message} #{url}#{detail}"


module.exports = () ->
  new SlackMessenger
