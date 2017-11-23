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

    def self.watch_gmail(current_user)
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
         
      watch_request = Google::Apis::GmailV1::WatchRequest.new
      watch_request.topic_name = 'projects/talentwiz-145409/topics/talentwiz-gcloud'
      watch_request.label_ids = ['INBOX']

      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      service.watch_user('me', watch_request)
    end

    def self.send_message(email, current_user)
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
      
      binding.pry

      message = Google::Apis::GmailV1::Message.new(raw: email.to_s, content_type: "text/html")
      @response = service.send_user_message('me', message)
      # client_message.update(thread_id: @response.thread_id)
    end
    
    def get_gmail_attribute(gmail_data, attribute)
      headers = gmail_data['payload']['headers']
      array = headers.reject { |hash| hash['name'] != attribute }
      array.first['value']
    end

    def self.create_message(historyId, current_user)
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
      
      #Get the messages that have been created since the last update
      @messages = service.list_user_histories('me', start_history_id: historyId)
      # How many Messages have been created
      @messages.history.first.messages_added.count
      # What is the label of new message
      # @messages.history.first.messages_added.first.message.label_ids == ["SENT"]

      #Get Message
      @messageId = service.list_user_histories('me', start_history_id: 323053).history.first.messages.first.id
      @message = service.get_user_message('me', @messageId )

      #set email criteria 
      @subject = get_gmail_attribute(@message, "Subject")
      @threadId = @message.thread_id
      @user_email = get_gmail_attribute(@message, "To").split('<')[1].split('>').first
      @user = user
      @company = user.company
      @sender = get_gmail_attribute(@message, "From").split('<')[1].split('>').first
      
      #find Candidate
      @candidate = Candidate.where(company_id: @company.id, email: @sender).first
      #find Client

      #create message for Canddiate
      if @candidate.present?  
        # Get Message Details
        if @message.payload.parts.last.mime_type == "text/plain" 
          @content =  @message.payload.parts.last.body.data.gsub("\r\n", "<br>")
          @content =  @content.gsub("<br><br><br>", "")
        elsif @message.payload.parts.last.mime_type "text/html"
          @content =  @message.payload.parts.last.body.data.gsub("\r\n", "")
          @content =  @content.gsub(/\"/, "")
          @content = @content.split("<div dir=ltr>")[1]
          @content = @content.split("<div class=gmail_extra>")[0]
          @msg = @content
          
          # if @content.include?("<div class=gmail_extra>")   
          # else
          #   @content = @content.split("<div id=Signature>")[0].split("<p>")[1..-1].join()
          #   @msg = @content
          # end
        end
        
        if @candidate.conversation.present?
          Message.create(conversation_id: @candidate.conversation.id, 
            body: @msg, subject: @subject, email_id: msgId, thread_id: @threadId, 
            candidate_id: @candidate.id)
        else 
          Conversation.create(candidate_id: @candidate.id, company_id: @company.id)   
          @conversation = Candidate.find(@candidate.id).conversation
          Message.create(conversation_id: @conversation.id, 
            body: @msg, subject: @subject, email_id: msgId, thread_id: @threadId, 
            candidate_id: @candidate.id)
        end
      else
        return nil
      end
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
  end

  class Calendar
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

    def self.create_event
    end

    def self.update_event
    end
  end

  private 
   
  def get_gmail_attribute(gmail_data, attribute)
    headers = gmail_data['payload']['headers']
    array = headers.reject { |hash| hash['name'] != attribute }
    array.first['value']
  end
end