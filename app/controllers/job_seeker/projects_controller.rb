class JobSeeker::ProjectsController < JobSeekersController
  layout "job_seeker"
  before_filter :require_user
  # before_filter :profile_sign_up_complete, :only => [:index]
  def index
    @projects = current_user.projects
    @social_links = current_user.social_links
    @avatar = current_user.user_avatar

    if current_user.background_image.present?
      @background = current_user.background_image
    else
      @background = BackgroundImage.new
    end
  end
  
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.js
    end
  end 

  def new
    @project = Project.new
    @attachment = Attachment.new
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save 
        update_attachments(@project)
        @projects = current_user.projects
        format.js
      else
        render :new
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)

    respond_to do |format|
      if @project.save 
        update_attachments(@project)
        @projects = current_user.projects
        format.js
      else
        render :new
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.js
    end
  end

  private 

  def update_attachments(project)
    @attachments = params[:attachment].split(',')
    @attachments.delete('')

    @attachments.each do |id|
      @attachment = Attachment.find(id.to_i)
      @attachment.update_attributes(project_id: project.id)
    end
  end

  def project_params 
    params.require(:project).permit(:user_id, :title, :description, :problem, :solution)
  end
end