class Business::CommentsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @comments = @candidate.applications.first.comments
    else
      @application = Application.find(params[:application_id])
      @comments = @application.comments
    end

    respond_to do |format|
      format.js
    end 
  end

  def new 
    if params[:application_id].present?
      @comment = Comment.new
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
    else
      @comment = Comment.new
      @candidate = Candidate.find(params[:candidate_id])
    end

    respond_to do |format|
      format.js
    end
  end

  def create 
    # @regex = params[:comment][:body].scan /@([\w]+\s[\w]+)/
    build_proper_association

    respond_to do |format| 
      if @comment.save 
        # track_activity @comment
        format.js 
      end
      #   if @regex.present? 
      #     @regex.each do |user|
      #       user = User.where(full_name: user.first).first
      #       @mention = Mention.create(user_id: current_user.id, mentioned_id: user.id, comment_id: @comment.id)
      #       Notification.create(user_id: user.id, trackable: @mention, action: 'create')
      #     end
      #   end
        
      # else
      #   flash[:error] = "Sorry something went wrong"
      #   redirect_to :back
      # end
    end
  end

  def add_note_multiple   
    applicant_ids = params[:applicant_ids].split(',')
    applicant_ids.each do |id| 
      @application = Application.find(id)
      @job = Job.find(@application.job_id)
      @comment = Comment.create(body: params[:comment], user_id: current_user.id, application_id: @application.id)  
    end
    track_activity(@comment, "create")
    redirect_to :back
  end

  private 

  def comment_params 
    params.require(:comment).permit(:body, :user_id)
  end

  def build_proper_association
    if params[:client_contact_id].present? 
      @contact = ClientContact.find(params[:client_contact_id])
      @comment = @contact.comments.build(comment_params)
    elsif params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @comment = @candidate.comments.build(comment_params)
    else
      @application = Application.find(params[:application_id])
      @candidate = @application.candidate

      if @candidate.manually_created == true 
        @applicant = @candidate
      else
        @applicant = @candidate.user.profile
      end
      @comment = @application.comments.build(comment_params)
    end
  end
end