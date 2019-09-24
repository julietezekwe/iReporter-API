class IncidentsController < ApplicationController
  before_action :set_incident, only: :show
  def create
    @incident = current_user.reported_incidents.create!(incident_params)
    response = {
      message: Message.report_success,
      data: @incident
    }
    json_response(response, :created)
  end

  def show
    json_response({ data: @incident }, :ok)
  end
  
  private

  def incident_params
    params.permit(:title, :evidence, :narration, :location, :status, :incident_type_id)
  end

  def set_incident
    @incident = Incident.find(params[:id])
  end
end
