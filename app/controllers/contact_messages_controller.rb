class ContactMessagesController < ApplicationController

  def create
    @contact = ContactMessage.new(message_params)
    
    if @contact.save
      AppMailer.send_contact_message(@contact).deliver
      redirect_to contact_path
      flash[:success] = "Thanks for reaching out! We will get in touch with you as soon as possible"
    else
      redirect_to contact_path
      flash[:danger] = "Oh no! Something went wrong. Please try again."
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(:first_name, :last_name, :phone, :company, :email, :message)
  end
end