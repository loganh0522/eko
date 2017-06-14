class Business::CommentsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  before_filter :load_commentable, except: [:new, :destroy, :update, :add_note_multiple]
  before_filter :new_commentable, only: [:new]

  def index
    @comments = @commentable.comments

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
      end
    end
  end

  def destroy
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
      @comment = @application.comments.build(body: params[:comment], user_id: current_user.id)
      @comment.save
    end
    track_activity(@comment, "create")
    redirect_to :back
  end

  private 

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