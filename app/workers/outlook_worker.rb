class OutlookWorker 
  include Sidekiq::Worker 

  def perform(user_id)
    @user = User.find(user_id)
    OutlookWrapper::User.update_subscription(@user)
  end
end