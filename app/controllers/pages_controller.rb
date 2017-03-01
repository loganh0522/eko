class PagesController < ApplicationController 
  before_filter :user_logged_in


  def home
    
  end
  
  def pricing

  end

  def job_seeker

  end

  def features
  end
  
  def contact
    @contact = ContactMessage.new
  end

  def demo
    @demo = Demo.new
  end
end
