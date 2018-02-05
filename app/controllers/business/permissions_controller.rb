class Business::PermissionsController < ApplicationController
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    @permissions = current_company.permissions
  end

  def new
    @permission = Permission.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @permission = Permission.new(permission_params) 

    respond_to do |format| 
      if @permission.save 
        @permissions = current_company.permissions
        format.js
      else
        render_errors(@permission)
        format.js
      end
    end
  end

  def edit
    @permission = Permission.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @permission = Permission.find(params[:id])

    respond_to do |format|
      if @permission.update(permission_params)
        @permissions = current_company.permissions
        format.js
      else
        render_errors(@permission)
        format.js
      end 
    end
  end

  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy


    respond_to do |format|
      format.js
    end
  end


  private

  def permission_params
    params.require(:permission).permit(
      :name,
      :company_id,
      :create_job, 
      :view_all_jobs,
      :edit_job,
      :advertise_job,
      :add_team_members,

      :create_candidates,
      :edit_candidates,
      :view_all_candidates,
      :move_candidates,

      :create_tasks,
      :view_all_tasks,
      :assign_tasks,

      :send_messages,
      :view_all_messages,
      :view_section_messages,

      :create_event,
      :view_events,
      :send_event_invitation,
      :view_all_events,

      :view_analytics,
      :edit_career_portal,
      :access_settings)
  end

  def render_errors(permission)
    @errors = []

    permission.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end
end