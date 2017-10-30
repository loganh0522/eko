class Business::TagsController < ApplicationController
  layout "business"
  # filter_access_to :all
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  
  def index
    @tags = current_company.tags
  end

  def new
    @candidate = Candidate.find(params[:candidate_id]) if params[:candidate_id].present?
    @tag = Tag.new

    respond_to do |format|
      format.js 
    end
  end

  def create 
    @company_tags = current_company.tags   
    respond_to do |format|
      if params[:applicant_ids].present?
        add_tag_to_multiple
        format.js
      elsif params[:tag][:candidate_id].present?
        add_to_single_app
        format.js
      else 
        @tag = Tag.new(tag_params)
        if @tag.save
          @tags = current_company.tags
          format.js
        end
      end
    end 
  end

  def destroy
    if params[:candidate_id].present? 
      @tagging = Tagging.where(candidate_id: params[:candidate_id], tag_id: params[:id]).first
      @tag = Tag.find(params[:id])
      @tagging.destroy
    else
      @tag = Tag.find(params[:id])
      @tag.destroy
    end

    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    @tags = current_company.tags.order(:name).where("name ILIKE ?", "%#{params[:term]}%") 
    render :json => @tags.to_json 
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :company_id)
  end

  def add_to_single_app
    @candidate = Candidate.find(params[:tag][:candidate_id])
    @tag = Tag.where(name: (params[:tag][:name].titleize), company_id: current_company.id).first
    @candidate_tags = @candidate.tags
    
    if !@candidate_tags.include?(@tag) 
      if @company_tags.include?(@tag)
        Tagging.create(candidate_id: params[:tag][:candidate_id], tag_id: @tag.id)
      else
        @tag = Tag.new(tag_params)
        @tag.company = current_company   
        if @tag.save 
          Tagging.create(candidate_id: params[:tag][:candidate_id], tag_id: @tag.id)
        end
      end
    end 
  end

  def add_tag_to_multiple
    @tag = Tag.where(name: (params[:tag][:name].titleize), company_id: current_company.id).first
    @candidate_ids = params[:applicant_ids].split(',')   
    
    @candidate_ids.each do |id|
      @candidate_tags = Candidate.find(id).tags
      if !@candidate_tags.include?(@tag) 
        if @company_tags.include?(@tag) 
          Tagging.create(candidate_id: id, tag_id: @tag.id)
        else
          @tag = Tag.new(tag_params)
          @tag.company = current_company   
          if @tag.save 
            Tagging.create(candidate_id: id, tag_id: @tag.id)
          end
        end
      end
    end
  end
end