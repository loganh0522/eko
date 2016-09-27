class ForgotPasswordsController < ApplicationController
  def create 
    user = User.where(email: params[:email]).first
    if user 
      generate_token(user)
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank" : "This email does not exist"
      redirect_to forgot_password_path
    end
  end

  def confirm 

  end

  private 

  def generate_token(user) 
    @token = SecureRandom.urlsafe_base64
    user.update_column(:token, @token)
  end

end