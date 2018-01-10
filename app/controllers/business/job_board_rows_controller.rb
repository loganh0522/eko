class Business::JobBoardRowsController < ApplicationController 
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @section = JobBoardRow.new
    @job_board = JobBoard.find(params[:job_board_id])
    @section_type = params[:kind]
    @photo = MediaPhoto.new
    @member = TeamMember.new
    
    respond_to do |format|
      format.js
    end
  end

  def create   
    @job_board = JobBoard.find(params[:job_board_id])
    @job_board_header = @job_board.job_board_header
    
    if params[:job_board_row][:video_link].present? 
      video_parse_function
      @section = JobBoardRow.new(job_board_row_params.merge!(youtube_id: @video_id ))
    elsif params[:job_board_row][:kind] == "Text" || params[:job_board_row][:kind] == "Photo"
      @photos = params[:media_photo].split(',')
      @photos.delete('')
      @section = JobBoardRow.new(create_params)  
    else
      @section = JobBoardRow.new(create_params)  
    end

    
    respond_to do |format|
      if @section.save   
        if params[:job_board_row][:kind] == 'Team'
          update_team_members
        elsif params[:job_board_row][:kind] == "Text" || params[:job_board_row][:kind] == "Photo"
          @photos.each do |id|
            photo = MediaPhoto.find(id).update_attributes(job_board_row_id: @section.id)
          end
        end
        
        @sections = @job_board.job_board_rows
        format.js
      end
    end
  end

  def edit 
    respond_to do |format|
      @job_board = JobBoard.find(params[:job_board_id])
      @section = JobBoardRow.find(params[:id])
      
      @job_board_header = @job_board.job_board_header
      @section_type = @section.kind
      
      

      if @section.kind == 'Photo' || @section.kind == 'Text'
        @photo = MediaPhoto.new
      elsif @section.kind == 'Team'
        @member = TeamMember.new
      else 
        @photo = @section.media_photos.first
      end

      format.js
    end
  end

  def update
    @section = JobBoardRow.find(params[:id])
    @job_board = JobBoard.find(params[:job_board_id])
    @job_board_header = @job_board.job_board_header

    if params[:job_board_row][:video_link].present? 
      video_parse_function
      @section = JobBoardRow.new(job_board_row_params.merge!(youtube_id: @video_id ))
    elsif params[:job_board_row][:kind] == 'Team'
      update_team_members
    elsif params[:job_board_row][:kind] == "Text" || params[:job_board_row][:kind] == "Photo"
      @photos = params[:media_photo].split(',')
      @photos.delete('')
      @photos.each do |id|
        photo = MediaPhoto.find(id).update_attributes(job_board_row_id: @section.id)
      end
    end

    respond_to do |format|
      if @section.update(job_board_row_params)
        @sections = @job_board.job_board_rows
        format.js
      end
    end
  end

  def destroy
    @section = JobBoardRow.find(params[:id])
    @section.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def video_parse_function
    regex = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
    link = params[:job_board_row][:video_link]
    @video_id = link.match(regex)[7]
  end

  def update_team_members
    params[:job_board_row][:team_members_attributes].each do |member|
      @member = TeamMember.find(member.first)
      @member.update_attributes(position: member.last[:position],
        name: member.last[:name], details: member.last[:details])
      @section.team_members << @member
    end
  end

  def job_board_row_params
    params.require(:job_board_row).permit(:description, :job_board_id, :kind, 
      :layout, :video_link, :subheader, :header, :position, 
      media_photos_attributes: [:id, :file_name, :_destroy],
      team_members_attributes: [:id, :position, :details, :file, :name, :_destroy])
  end

  def create_params
    params.require(:job_board_row).permit(:description, :job_board_id, :kind, 
      :layout, :video_link, :subheader, :header, :position, 
      media_photos_attributes: [:id, :file_name, :_destroy])
  end
end