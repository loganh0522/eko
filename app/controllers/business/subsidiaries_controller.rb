class Business::SubsidiariesController < ApplicationController 
  before_filter :require_user
  before_filter :belongs_to_company

  def index

  end

  def new
    @subsidiary = Subsidiary.new
  end
end