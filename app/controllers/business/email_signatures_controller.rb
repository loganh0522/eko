class Business::EmailSignaturesController < ApplicationController

  def edit
    @signature = EmailSignature.find(params[:id])

    respond_to do |format| 
      format.js
    end
  end

  def update
    @signature = EmailSignature.find(params[:id])
    respond_to do |format|
      if @signature.update(e_temp_params)
        format.js
      end
    end
  end

  private 

  def e_temp_params
    params.require(:email_signature).permit(:signature, :user_id)
  end
end