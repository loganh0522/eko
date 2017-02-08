class Business::CommentsController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def create 
    # @regex = params[:comment][:body].scan /@([\w]+\s[\w]+)/   
    @comment = Comment.new(comment_params)
    
    @application = Application.find(params[:application_id])
    @comments = @application.comments
    @activities = current_company.activities.where(application_id: @application.id).order('created_at DESC')
    
    respond_to do |format| 
      if @comment.save 
        track_activity @comment
        @application = Application.find(params[:application_id])
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
    params.require(:comment).permit(:body, :user_id, :application_id)
  end
end