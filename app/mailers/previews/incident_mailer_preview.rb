class IncidentMailerPreview < ActionMailer::Preview
  def status_notification
    IncidentMailer.status_notification
  end
end