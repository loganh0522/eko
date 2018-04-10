class Business::JobBoardRowsController < ApplicationController 
  layout "business"
  
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?

  def new 
    @section = JobBoardRow.new
    @photo = MediaPhoto.new
    @member = TeamMember.new
    
    @subsidiary = Subsidiary.find(params[:subsidiary]) if params[:subsidiary].present?

    respond_to do |format|
      format.js
    end
  end

  def create   
    if params[:subsidiary].present? 
      @company = Subsidiary.find(params[:subsidiary]).subsidiary
    else 
      @company = current_company
    end

    @job_board = @company.job_board
    
    if params[:job_board_row][:video_link].present? 
      video_parse_function
      
      @section = JobBoardRow.new(job_board_row_params.merge!(youtube_id: @video_id, 
        job_board: @job_board, position: row_position))
    else
      @section = JobBoardRow.new(create_params.merge!(job_board: @job_board, position: row_position))  
    end
    
    respond_to do |format|
      if @section.save   
        if params[:job_board_row][:kind] == 'Team'
          update_team_members
        elsif params[:job_board_row][:kind] == "Text-Photo" || params[:job_board_row][:kind] == "Photo"
          @photos = params[:media_photo].split(',')
          @photos.delete('')
          @photos.each do |id|
            photo = MediaPhoto.find(id).update_attributes(job_board_row_id: @section.id)
          end
        end
        
        @sections = @job_board.job_board_rows
        @job_board_header = @job_board.job_board_header
    
        format.js
      end
    end
  end

  def edit 
    @section = JobBoardRow.find(params[:id])
    # @job_board_header = @job_board.job_board_header
    @section_type = @section.kind

    respond_to do |format|
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
    @job_board = current_company.job_board
    
    if params[:job_board_row][:video_link].present? 
      video_parse_function
      @section = JobBoardRow.new(job_board_row_params.merge!(youtube_id: @video_id ))
    elsif params[:job_board_row][:kind] == "Text" || params[:job_board_row][:kind] == "Photo"
      @photos = params[:media_photo].split(',')
      @photos.delete('')
      @photos.each do |id|
        photo = MediaPhoto.find(id).update_attributes(job_board_row_id: @section.id)
      end
    end

    respond_to do |format|
      if @section.update(job_board_row_params)
        @job_board_header = @job_board.job_board_header
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

  def sort
    params[:section].each_with_index do |id, index|
      JobBoardRow.update(id, {position: index + 1})
    end

    @job_board = current_company.job_board
    @job_board_header = @job_board.job_board_header
    @sections = @job_board.job_board_rows
  end


  private

  def video_parse_function
    regex = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/
    link = params[:job_board_row][:video_link]
    @video_id = link.match(regex)[7]
  end

  def row_position    
    current_company.job_board.job_board_rows.count + 1
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