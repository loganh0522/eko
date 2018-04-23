class Business::InterviewKitsController < ApplicationController
  # layout "business"
  # before_filter :require_user
  # before_filter :belongs_to_company
  # before_filter :trial_over
  # before_filter :company_deactivated?

  # def index 
  #   if params[:subsidiary].present?
  #     @subsidiary = Subsidiary.find(params[:subsidiary])
  #     @interview_kits = @subsidiary.subsidiary.interview_kits
  #   else
  #     @interview_kits = current_company.interview_kits
  #   end
  # end

  # def show 
  #   @interview_kit = InterviewKit.find(params[:id])
  #   @questions = @interview_kit.questions
  #   @scorecard = @interview_kit.scorecard
  #   @assessment = Assessment.new
  # end

  # def new
  #   @interview_kit = InterviewKit.new
  #   @scorecard = Scorecard.new

  #   respond_to do |format| 
  #     format.js
  #   end
  # end

  # def create 
  #   @interview_kit = InterviewKit.new(interview_kit_params.merge!(company: current_company)) 
  #   # @interview_kit.build.scorecard
  #   respond_to do |format|
  #     if @interview_kit.save
  #       @interview_kits = current_company.interview_kits
  #     else 
  #       render_errors(@interview_kit)
  #     end
  #     format.js
  #   end
  # end

  # def edit
  #   @interview_kit = InterviewKit.find(params[:id])

  #   respond_to do |format| 
  #     format.js
  #   end
  # end

  # def update
  #   @interview_kit = InterviewKit.find(params[:id])
    
  #   respond_to do |format|
  #     if @interview_kit.update(interview_kit_params)
  #       @interview_kits = current_company.interview_kits
  #     else 
  #       render_errors(@interview_kit)  
  #     end
  #     format.js
  #   end
  # end

  # def destroy
  #   @interview_kit = InterviewKit.find(params[:id])
  #   @interview_kit.destroy

  #   respond_to do |format|
  #     @interview_kits = current_company.interview_kits
  #     format.js
  #   end
  # end

  # private 

  # def interview_kit_params 
  #   params.require(:interview_kit).permit(:title,
  #     scorecard_attributes: [:id,
  #       scorecard_sections_attributes: [:id, :body, :_destroy, 
  #         section_options_attributes:[:id, :body, :_destroy]]])  
  # end


  # def render_errors(interview_kit)
  #   @errors = []

  #   interview_kit.errors.messages.each do |error| 
  #     @errors.append([error[0].to_s, error[1][0]])
  #   end 
  # end
end