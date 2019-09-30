require "rails_helper"

RSpec.describe IncidentMailer, type: :mailer do
  let!(:reporter) { create(:reporter) }
  let!(:incident_type) { create(:incident_type) }
  let!(:incident) { create(:incident, reporter_id: reporter.id, incident_type_id: incident_type.id) }

  describe 'Status notification' do
    subject!(:mail) { described_class.status_notification(incident, 'http://fake-link.com') }

    context 'when email sent' do
      it "renders the headers" do
        expect(mail.to).to eq([reporter.email])
        expect(mail.from).to eq(["support@ireporter.com"])
      end

      it "renders the body" do
        expect(mail.body.encoded).
          to match("Your reported Incident with title")
      end
    end
  end
end
