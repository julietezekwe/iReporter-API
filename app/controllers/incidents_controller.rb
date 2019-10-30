class IncidentsController < ApplicationController
  before_action :set_incident, except: [:create, :index, :search]

  def index
    @incidents = Incident.all
    return render json: @incidents, adapter: :json unless @incidents.empty?
    json_response({ message: Message.records_not_found })
  end

  def create
    @incident = current_user.reported_incidents.create!(create_params)

    json_response({
      message: Message.report_success('Incident'),
      data: @incident
    }, :created)
  end

  def show
    render json: @incident, adapter: :json
  end

  def update
    return json_response({ error: Message.unauthorized }, 401) unless is_mine?(@incident) || is_admin?
    return json_response({ error: Message.update_failure }, 422) unless is_draft?(@incident) || is_admin?

    update_params = if is_admin? then update_status_params else update_all_params end
    @incident.update(update_params)

    if is_admin?
      incident_link = "#{request.protocol}#{request.host_with_port}/incidents/#{@incident.id}"
      IncidentMailer.status_notification(@incident,incident_link).deliver_now
    end

    json_response({
      message: Message.update_success('Incident'),
      data: @incident
    })
  end

  def destroy
    return json_response({ error: Message.unauthorized }, 401) unless is_mine?(@incident) || is_admin?
    return json_response({ error: Message.delete_failure }, 422) unless is_draft?(@incident) || is_admin?

    @incident.destroy
    json_response({ message: Message.delete_success("Incident") })
  end

  def search
    response = Incident.__elasticsearch__.search(params[:query]).results

    if response.total > 0 then
      return json_response({
        results: response.results,
        total: response.total
      })
    end

    json_response({ message: "No Incident matches #{params[:query]}" })
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

  def is_draft?(incident)
    incident[:status] == "draft"
  end
end
