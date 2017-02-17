class Business::QuestionAnswersController < JobSeekersController 
  before_filter :require_user
  
  def new 
    @answer = QuestionAnswer.new
  end

  def create

  end

end