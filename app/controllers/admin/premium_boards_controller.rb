class Admin::PremiumBoardsController < ApplicationController
  layout "admin"
  before_filter :require_user
  # before_filter :require_admin

  def index
    @job_boards = PremiumBoard.all
    
    respond_to do |format|
      format.html
    end
  end

  def new
    @job_board = PremiumBoard.new
    @job_board.posting_durations.new
  end

  def create 
    @job_board = PremiumBoard.new(board_params)
    

    if @job_board.save
      redirect_to admin_premium_boards_path
    else
      format.js
    end
  end

  def edit
    @job_board = PremiumBoard.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @job_board = PremiumBoard.find(params[:id])
    if @job_board.update(board_params)
     redirect_to admin_premium_boards_path
    else
      format.js
    end
  end

  def destroy

  end

  private 

  def board_params
    params.require(:premium_board).permit(:name, :description, :website, :kind, :logo,
      posting_durations_attributes: [:id, :kind, :duration, :price, :real_price, :name, :_destroy])
  end

end 