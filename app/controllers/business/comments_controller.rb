class Business::CommentsController < ApplicationController 
  layout "business"

  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_commentable, except: [:new, :destroy, :update, :add_note_multiple, :new_multiple]
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
    @candidate = Candidate.find(params[:candidate_id])

    if params[:job].present? 
      @comments = @candidate.job_comments(params[:job])
    else
      @comments = @candidate.comments
    end

    respond_to do |format|
      format.js
    end 
  end

  def new 
    @comment = Comment.new
    @job = Job.find(params[:job]) if params[:job].present?

    respond_to do |format|
      format.js
    end
  end

  def create 
    @new_comment = @commentable.comments.build(comment_params)
    @comment = Comment.new

    if @new_comment.save 
      if @commentable.class == Job
        @comments = @commentable.comments
        track_activity @new_comment, 'job_note', nil, params[:job_id]
      elsif @commentable.class != Job && params[:comment][:job_id].present?
        @comments = Comment.where(commentable_type: "Candidate", commentable_id: @commentable.id, job_id: params[:comment][:job_id])
        track_activity @new_comment, 'create', current_company.id, @commentable.id, params[:comment][:job_id] 
      
      elsif @commentable.class == Candidate && !params[:comment][:job_id].present?
        @comments = @commentable.comments
        track_activity @new_comment, 'create', current_company.id, @commentable.id, params[:comment][:job_id] 
      elsif @commentable.class == Client
        @comments = @commentable.comments
        track_activity @new_comment, 'create', current_company.id, @commentable.id
      end
    else
      render_errors(@new_comment)
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

  def new_multiple
    @comment = Comment.new
    @job = Job.find(params[:job]) if params[:job].present?

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
        @comment = @candidate.comments.build(comment_params)
      else 
        @comment = @candidate.comments.build(comment_params)
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