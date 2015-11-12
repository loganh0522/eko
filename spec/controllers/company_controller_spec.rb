require 'spec_helper'

describe Company do 
  describe 'GET new' do 
    it "should set @company"
      get :new 
      expect(assigns(:company)).to be_instance_of(Company)
    end
  end

end

