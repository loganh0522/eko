class Business::CommentsController < ApplicationController 
  def create 
    @comment = Comment.new(comment_params)

    if @comment.save 
      redirect_to :back
    else
      flash[:error] = "Sorry something went wrong"
      redirect_to :back
    end
  end

  private 

  def comment_params 
    params.require(:comment).permit(:body, :user_id, :application_id)
  end
end