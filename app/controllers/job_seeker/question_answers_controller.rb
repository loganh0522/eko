class Business::QuestionAnswersController < JobSeekersController 
  before_filter :require_user
  before_filter :profile_sign_up_complete
  
  def new 
    @answer = QuestionAnswer.new
  end

  def create

  end

end