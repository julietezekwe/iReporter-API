class IncidentsController < ApplicationController
  def create
    @incident = current_user.reported_incidents.create!(incident_params)
    response = {
      message: Message.report_success,
      data: @incident
    }
    json_response(response, :created)
  end

  private

  def incident_params
    params.permit(:title, :evidence, :narration, :location, :status, :incident_type_id)
  end
end
