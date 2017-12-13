class OutlookWorker 
  include Sidekiq::Worker 

  def perform(user_id)
    @user = User.find(user_id)
    GoogleWrapper::Gmail.watch_gmail(@user)
  end
end