class DemosController < ApplicationController

  def create
    @demo = Demo.new(demo_params)
    if @demo.save
      AppMailer.send_demo_request(@demo).deliver
      redirect_to demo_path
      flash[:success] = "Thanks for reaching out! We will get in touch with you as soon as possible"
    else
      redirect_to demo_path
      flash[:danger] = "Oh no! Something went wrong. Please try again."
    end
  end

  private

  def demo_params
    params.require(:demo).permit(:first_name, :last_name, :phone, :email, :message, :company, :company_size, :company_website)
  end
end