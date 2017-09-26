class Business::CommentsController < ApplicationController 
  layout "business"
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_commentable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_commentable, only: [:new]

  def job_comments
    @comments = @commentable.comments
    @comment = Comment.new
    @job = @commentable
  end
  
  def client_comments
    @comments = @commentable.comments
    @comment = Comment.new
    @client = @commentable
  end

  def index
    if params[:application_id].present?
      @candidate = Application.find(params[:application_id]).candidate.id
    else
      @candidate = Candidate.find(params[:candidate_id]).id
    end
    
    where = {}
    where[:job_id] = params[:job_id] if params[:job_id].present?
    where[:commentable_id] = @candidate

    @comments = Comment.search("*", where: where)

    respond_to do |format|
      format.js
    end 
  end

  def new 
    @comment = Comment.new

    if @commentable.class == Application 
      @job = @commentable.job
      @commentable = @commentable.candidate
    end

    respond_to do |format|
      format.js
    end
  end

  def create 
    @new_comment = @commentable.comments.build(comment_params)
    @comment = Comment.new

    if @new_comment.save 
      @comments = @commentable.comments

      if @commentable.class == Job
        track_activity @new_comment, 'job_note', nil, params[:job_id]
      elsif @commentable.class != Job && params[:comment][:job_id].present?
        track_activity @new_comment, 'create', current_company.id, @commentable.id, params[:comment][:job_id]   
      else 
        track_activity @new_comment, 'create', current_company.id, @commentable.id
      end
      
    else
      render_errors(@comment)
    end
    respond_to do |format| 
      format.js 
    end
  end

  def edit 
    @comment = Comment.find(params[:id])
    @commentable = @commentable.commentable
    respond_to do |format| 
      format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])
    
    respond_to do |format| 
      if @comment.update(comment_params)
        format.js
      else
        render_errors(@comment)
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.js
    end
  end

  def add_note_multiple
    applicant_ids = params[:applicant_ids].split(',')
    
    applicant_ids.each do |id| 
      @candidate = Candidate.find(id)
      if params[:job_id].present?
        @job = Job.find(params[:job_id])
        @application = Application.where(candidate_id: @candidate.id, job: @job.id).first
        @comment = @application.comments.build(body: params[:comment], user_id: current_user.id)
      else 
        @comment = @candidate.comments.build(body: params[:comment], user_id: current_user.id)
      end
      @comment.save
    end
    # track_activity(@comment, "create")
    
    respond_to do |format| 
      format.js
    end
  end

  private 

  def render_errors(comment)
    @errors = []
    comment.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def comment_params 
    params.require(:comment).permit(:body, :user_id, :job_id)
  end

  def load_commentable
    resource, id = request.path.split('/')[-3..-1]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def new_commentable
    resource, id = request.path.split('/')[-4..-2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
end