class Business::RoomsController < ApplicationController
  layout "business"
  # filter_resource_access
  before_filter :require_user
  before_filter :belongs_to_company
  before_filter :trial_over
  before_filter :company_deactivated?
  include AuthHelper

  def new
    @room = Room.new

    respond_to do |format|
      format.js
    end
  end

  def create 
    @room = Room.new(room_params)

    respond_to do |format| 
      if @room.save
        @rooms = current_company.rooms
      else
        render_errors(@room)
      end
      format.js
    end
  end

  def edit
    @room = Room.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @room = Room.find(params[:id])

    respond_to do |format| 
      if @room.update(room_params)
        @rooms = current_company.rooms 
      else
        render_errors(@room)     
      end
      format.js
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    @room = current_company.candidates.order(:full_name).where("full_name ILIKE ?", "%#{params[:term]}%")
    render :json => Room.search(params[:term], where: {company_id: current_company.id}, 
      fields: [{full_name: :word_start}])
  end

  def outlook_token
    token = get_room_token_from_code params[:code]

    @outlookToken = OutlookToken.create(
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_at: Time.now + token.expires_in.to_i.seconds,
      )

    OutlookWrapper::User.set_room_token(@outlookToken)
    redirect_to business_company_path(current_company)
  end

  def get_availability
    @events = []
    @room = Room.find(params[:id])
    
    @e = OutlookWrapper::Calendar.get_events(@room)
    @e.each do |event| 
      @events << {:id => event.id, :title => event.subject, :start => DateTime.parse(event.start.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York"), :end => DateTime.parse(event.end.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York"), :editable => false}
    end

    render :text => @events.to_json
  end

  private

  def render_errors(room)
    @errors = []
    room.errors.messages.each do |error| 
      @errors.append([error[0].to_s, error[1][0]])
    end 
  end

  def room_params
    params.require(:room).permit(:name, :email, :company_id)
  end
end