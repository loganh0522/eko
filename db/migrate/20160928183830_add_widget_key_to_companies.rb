class AddWidgetKeyToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :widget_key, :string
    
    Company.all.each do |company|
      company.update_column(:widget_key, SecureRandom.urlsafe_base64)
    end
  end
end
