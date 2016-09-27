class CertificationsController < ApplicationController 
  def index
    @certifications = Certification.order(:name).where("name ILIKE ?", "%#{params[:term]}%")
    render :json => @certifications.to_json 
  end
end