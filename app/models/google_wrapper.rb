module GoogleWrapper 
require 'signet/oauth_2/client'
require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets.rb'

  class Gmail   
    attr_reader :error_message, :response
    def initialize(current_user)
      configure_client(current_user)
    end

    def self.configure_client(current_user)
      @client = Google::APIClient.new
      @client.authorization.access_token = current_user.google_token.access_token
      @client.authorization.refresh_token = current_user.google_token.refresh_token
      @client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
      @client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
      @client.authorization.refresh!
      @service = @client.discovered_api('gmail', 'v1')
    end

    def self.get_mail(current_user)
      configure_client(current_user)
      response = @client.execute(api_method: @service.users.messages.get) 
      @messages = JSON.parse(response.body)
    end

    def access_token
      if current_user.google_token.expired? 
        current_user.google_token.refresh!
        token = current_user.google_token.access_token
      else
        token = current_user.google_token.access_token
      end
      token
    end

    def self.get_messages(current_user)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token

      client = Signet::OAuth2::Client.new(access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.compose',
          'https://www.googleapis.com/auth/gmail.modify'],
        grant_type: 'authorization_code')
         
      
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client

      @messages = service.list_user_messages('me')
    end

    def self.send_message(email, current_user, client_message)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token
      client = Signet::OAuth2::Client.new(access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.send',
          'https://www.googleapis.com/auth/gmail.compose'],
        grant_type: 'authorization_code')
         
      
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client

      message = Google::Apis::GmailV1::Message.new(raw: email.to_s, content_type: "text/html")
      @response = service.send_user_message('me', message)
      client_message.update(thread_id: @response.thread_id)
    end
    
    def self.get_message_titles(message, current_user)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token
      client = Signet::OAuth2::Client.new(access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.compose',
          'https://www.googleapis.com/auth/gmail.modify'],
        grant_type: 'authorization_code')
         
      
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      
      @message = service.get_user_message('me', message.id)
    end

    def self.get_message_thread(thread, current_user)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token
      client = Signet::OAuth2::Client.new(access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.compose',
          'https://www.googleapis.com/auth/gmail.modify'],
        grant_type: 'authorization_code')
         
      
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      
      thread = service.get_user_thread('me', thread)
      return thread
    end
   
    def get_gmail_attribute(gmail_data, attribute)
      headers = gmail_data['payload']['headers']
      array = headers.reject { |hash| hash['name'] != attribute }
      array.first['value']
    end
  end
end