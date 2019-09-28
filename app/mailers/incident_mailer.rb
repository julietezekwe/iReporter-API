class IncidentMailer < ApplicationMailer
  def status_notification(incident, link)
    @incident = incident
    @reporter = incident.reporter
    @incident_link = link
    mail(to: @reporter.email, status: "[iReporter] Status change for Incident: #{incident.title}")
  end
end
