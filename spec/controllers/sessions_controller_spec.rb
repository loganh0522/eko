require "spec_helper" 

describe SessionsController do 
  describe "GET new" do 
    it "renders the new template for unauthenticated users" do 
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the business root path for authenticated users"  do 
      set_current_user 
      get :new 
      expect(response).to redirect_to business_root_path
    end
  end
  describe "POST create" do 

  end
end