class Business::DefaultStagesController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index   
    @stages = current_company.default_stages.order("position")
  end

  def new
    @stage = DefaultStage.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @stage = DefaultStage.new(stage_params) 
    @stages = current_company.default_stages.order("position")

    respond_to do |format| 
      if @stage.save & @stage.update_attribute(:position, new_stage_position(current_company))
        format.js
      else
        flash[:error] = "Sorry, something went wrong. Please try again."
        render :new
      end
    end
  end

  def edit
    @stage = DefaultStage.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @stage = DefaultStage.find(params[:id])

    respond_to do |format|
      if @stage.update(stage_params)
        format.js
      else
        format.json { render json: @stage.errors.full_messages,
                                   status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stage = DefaultStage.find(params[:id])
    @stage.destroy

    current_company.stages.each_with_index do |id, index| 
      DefaultStage.update(id, {position: index + 1})
    end

    respond_to do |format|
      format.js
    end
  end

  def sort
    params[:stage].each_with_index do |id, index|
      DefaultStage.update(id, {position: index + 1})
    end
    render nothing: true
  end

  private

  def stage_params
    params.require(:default_stage).permit(:name, :position, :company_id)
  end

  def new_stage_position(company)
    current_company.default_stages.count + 1
  end
end