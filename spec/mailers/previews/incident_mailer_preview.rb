# Preview all emails at http://localhost:3000/rails/mailers/incident_mailer
class IncidentMailerPreview < ActionMailer::Preview
  def status_notification
    IncidentMailer.status_notification
  end
end
