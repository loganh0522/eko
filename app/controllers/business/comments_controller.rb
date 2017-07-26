class Business::CommentsController < ApplicationController 
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_commentable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_commentable, only: [:new]

  def index
    @comments = @commentable.comments
    @comment = Comment.new
    respond_to do |format|
      format.js
    end 
  end

  def new 
    @comment = Comment.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @comment = @commentable.comments.build(comment_params)
    
    if @comment.save 
      @comments = @commentable.comments
      track_activity @comment
    else
      render_errors(@comment)
    end
    respond_to do |format| 
      format.js 
    end
  end

  def edit 
    @comment = @commentable
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
      
      end
      
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    Activity.where(trackable_id: @comment.id, trackable_type: "Comment").first.delete if Activity.where(trackable_id: @comment.id).first.present?
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
    params.require(:comment).permit(:body, :user_id)
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