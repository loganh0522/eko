class Business::CommentsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def index
    if params[:candidate_id].present?
      @candidate = Candidate.find(params[:candidate_id])
      @comments = @candidate.notes
    elsif params[:client_contact_id].present?
      @contact = ClientContact.find(params[:client_contact_id])
      @comments = @contact.comments
    elsif params[:client_id].present?
      @client = Client.find(params[:client_id])
      @comments = @client.comments
    else
      @application = Application.find(params[:application_id])
      @job = Job.find(params[:job_id])
      @comments = @application.comments
    end

    respond_to do |format|
      format.js
    end 
  end

  def new 
    @comment = Comment.new
    
    if params[:application_id].present?     
      @job = Job.find(params[:job_id])
      @application = Application.find(params[:application_id])
      @commentable = 'Application'
    elsif params[:client_contact_id].present?      
      @client = Client.find(params[:client_id])
      @contact = ClientContact.find(params[:client_contact_id])    
    else
      @candidate = Candidate.find(params[:candidate_id])
    end

    respond_to do |format|
      format.js
    end
  end

  def create 
    build_proper_association

    respond_to do |format| 
      if @comment.save 
        if params[:application_id].present?
          @job = Job.find(params[:job_id])
          @comments = Application.find(params[:application_id]).comments
        elsif params[:client_contact_id].present?
          @comments = @contact.comments
        end
        track_activity @comment
        format.js 
      end
    end
  end

  def edit 
    @comment = Comment.find(params[:id])
    @application = Application.find(@comment.commentable_id)
    @job = @application.apps

    respond_to do |format| 
      format.js
    end
  end

  def update
    @job = Job.find(params[:job_id])
    @comment = Comment.find(params[:id])
    @application = Application.find(params[:application_id])

    respond_to do |format| 
      if @comment.update(comment_params)
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


  def add_note_multiple   
    applicant_ids = params[:applicant_ids].split(',')
    applicant_ids.each do |id| 
      @application = Application.find(id)
      @job = Job.find(@application.job_id)
      @comment = @application.comments.build(comment_params)
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