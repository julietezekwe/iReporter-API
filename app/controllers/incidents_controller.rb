class IncidentsController < ApplicationController
  before_action :set_incident, except: [:create, :index, :search]

  def index
    @incidents_following = Incident.all.map do |incident|
      {
        incident: incident,
        follow_count: incident.follows.length
      }
    end
    @incidents = @incidents_following.sort_by { |hash| hash[:follow_count]}.reverse!
    return json_response({ data: @incidents }, :ok) unless @incidents.empty?
    json_response({ message: Message.records_not_found }, 200)
  end

  def create
    @incident = current_user.reported_incidents.create!(create_params)

    json_response({
      message: Message.report_success('Incident'),
      data: @incident
    }, :created)
  end

  def show
    json_response({ data: @incident }, :ok)
  end

  def update
    return json_response({ error: Message.unauthorized }, 401) unless my_incident?(@incident) || is_admin?
    return json_response({ error: Message.update_failure }, 422) unless draft_incident?(@incident) || is_admin?

    update_params = if is_admin? then update_status_params else update_all_params end
    @incident.update(update_params)

    if is_admin?
      incident_link = "#{request.protocol}#{request.host_with_port}/incidents/#{@incident.id}"
      IncidentMailer.status_notification(@incident,incident_link).deliver_now
    end

    json_response({
      message: Message.update_success,
      data: @incident
    }, :ok)
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless my_incident?(@incident)
    return json_response({ error: Message.delete_failure }, 422) unless draft_incident?(@incident)

    @incident.destroy
    json_response({ message: Message.delete_success("Incident") }, :ok)
  end

  def search
    response = Incident.__elasticsearch__.search(params[:query]).results

    if response.total > 0 then
      return json_response({
        results: response.results,
        total: response.total
      }, :ok)
    end

    json_response({ message: "No Incident matches #{params[:query]}" }, :ok)
  end
  
  private

  def create_params
    params.permit(:title, :evidence, :narration, :location, :status, :incident_type_id)
  end

  def update_all_params
    params.permit(:title, :evidence, :narration, :location, :incident_type_id)
  end

  def update_status_params
    params.permit(:status)
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
