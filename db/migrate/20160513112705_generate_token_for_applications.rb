class GenerateTokenForApplications < ActiveRecord::Migration
  def change
    Application.all.each do |application|
      application.update_column(:token, SecureRandom.urlsafe_base64)
    end
  end
end
