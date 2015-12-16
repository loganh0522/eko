class Business::InvitationsController < ApplicationController
  before_filter :require_user
  before_filter :belongs_to_company

  def new 
    @invitation = Invitation.new
  end
end