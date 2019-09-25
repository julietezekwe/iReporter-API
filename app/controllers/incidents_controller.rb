class IncidentsController < ApplicationController
  before_action :set_incident, except: :create

  def create
    @incident = current_user.reported_incidents.create!(create_params)
    response = {
      message: Message.report_success,
      data: @incident
    }
    json_response(response, :created)
  end

  def show
    json_response({ data: @incident }, :ok)
  end

  def update
    return json_response({ error: Message.unauthorized }, 401) unless my_incident?(@incident)
    return json_response({ error: Message.update_failure }, 422) unless draft_incident?(@incident)

    @incident.update(update_params)
    response = {
      message: Message.update_success,
      data: @incident
    }
    json_response(response, :ok)
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless my_incident?(@incident)
    return json_response({ error: Message.delete_failure }, 422) unless draft_incident?(@incident)

    @incident.destroy
    json_response({ message: Message.delete_success }, :ok)
  end
  
  private

  def create_params
    params.permit(:title, :evidence, :narration, :location, :status, :incident_type_id)
  end

  def update_params
    params.permit(:title, :evidence, :narration, :location, :incident_type_id)
  end

  def set_incident
    @incident = Incident.find(params[:id])
  end

  def my_incident?(incident)
    incident[:reporter_id] == current_user.id
  end

  def draft_incident?(incident)
    incident[:status] == "draft"
  end
end
