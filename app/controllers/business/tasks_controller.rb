class Business::TasksController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    @tasks = current_company.tasks
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @job = current_company.jobs.first
    @interviews_by_date = @job.interviews.group_by(&:interview_date)
    # if params[:candidate_id].present?
    #   @candidate = Candidate.find(params[:candidate_id])
    #   @comments = @candidate.applications.first.comments
    # else
    #   @application = Application.find(params[:application_id])
    #   @job = Job.find(params[:job_id])
    #   @comments = @application.comments
    # end
  end

  def new 
    @task = Task.new

    if params[:application_id].present?
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
    elsif params[:client_contact_id].present?
      @client = Client.find(params[:client_id])
      @contact = ClientContact.find(params[:client_contact_id]) 
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
        if params[:application_id].present?
          @job = Job.find(params[:job_id])
          @comments = Application.find(params[:application_id]).comments
        end
        track_activity @comment
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

  def edit 
    @comment = Comment.find(params[:id])
    @application = Application.find(params[:application_id])
    @job = Job.find(params[:job_id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @job = Job.find(params[:job_id])
    @task = Comment.find(params[:id])
    @application = Application.find(params[:application_id])

    respond_to do |format| 
      if @task.update(comment_params)
        format.js
      end
    end
  end

  def destroy
    @job = Job.find(params[:job_id])
    @application = Application.find(params[:application_id])
    @comment = Comment.find(params[:id])
    Activity.where(trackable_id: @comment.id).first.delete
    @comment.destroy

    respond_to do |format|
      format.js
    end
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
      @task = @candidate.comments.build(comment_params)
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