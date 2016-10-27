module GoogleWrapper 
  class Gmail
    def access_token
      if current_user.google_token.expired? 
        current_user.google_token.refresh!
        token = current_user.google_token.access_token
      else
        token = current_user.google_token.access_token
      end
      token
    end

    def self.get_details
      token = User.find(21).google_token.access_token
      client = Signet::OAuth2::Client.new(access_token: session[:user_id].google_token.access_token)    
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
    
      @labels_list = service.get_user_profile('me')
    end
     
    def get_gmail_attribute(gmail_data, attribute)
      headers = gmail_data['payload']['headers']
      array = headers.reject { |hash| hash['name'] != attribute }
      array.first['value']
    end
  end
end