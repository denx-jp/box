class UpdateHistory < ActiveRecord::Base
  after_save :post_to_slack

  private
  def post_to_slack
    return unless ENV.include?("SLACK_WEBHOOK_URL")

    url = "#{Thread.current[:request].base_url}/files/#{self.path}"
    link = "[/#{self.path}](#{url})"
    message =
    case self.action
    when "create" then ":package: 新しいファイルがアップロードされました\n#{link}"
    when "create_dir" then ":file_folder: 新しいフォルダが作成されました\n#{link}"
    when "update" then ":package: ファイルが更新されました\n#{link}"
    when "delete" then ":x: ファイルが削除されました\n#{self.path}"
    end
    attachment = {
      fallback: "[DENX BOX]#{message}",
      text: message,
      color: self.action == "delete" ? "danger" : "good",
    }
    if [".gif", ".png", ".jpg", ".jpeg"].include?(File.extname(url))
      attachment[:thumb_url] = url
    end

    slack = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"]
    slack.ping "", attachments: [attachment]
  end
end
