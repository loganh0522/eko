class JobSeeker::UsersController < JobSeekersController 
  layout :set_layout
  before_filter :require_user
  # before_filter :profile_sign_up_complete
  def show 
    @user = current_user
    @social_links = current_user.social_links
    @avatar = current_user.user_avatar
    @work_experiences = @user.organize_work_experiences
    
    if current_user.background_image.present?
      @background = current_user.background_image
    else
      @background = BackgroundImage.new
    end 
    if request.subdomain.present? && request.subdomain != 'www'
      @job_board = JobBoard.find_by_subdomain!(request.subdomain) 
    end
  end

  def edit
    @user = current_user

    respond_to do |format|
      format.js 
    end
  end

  def update
    @user = current_user
    
    respond_to do |format|
      if @user.update(user_params)
        convert_location 
        format.js
      else
        render_errors(@user)
        format.js
      end
    end
  end

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :tag_line, :location,
      social_links_attributes: [:id, :url, :kind, :_destroy] )
  end

  def render_errors(experience)
    @errors = []
    experience.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end  
  end

  def set_layout
    if request.subdomain.present? && request.subdomain != 'www'
      if @job_board.kind == "basic"
        "career_portal_profile"
      else
        "career_portal_profile"
      end
    else
      "job_seeker"
    end
  end

  def convert_location
    location = params[:user][:location].split(',')
    if location.count == 3
      @user.update_column(:city, location[0])
      @user.update_column(:province, location[1])
      @user.update_column(:country, location[2])
    else
      @user.update_column(:city, location[0])
      @user.update_column(:country, location[1])
    end
  end
end