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

    def self.send_message(email, id, current_user)
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

      @message = Message.find(id)
      @message.update_attributes(email_id: @response.id, thread_id: @response.thread_id)
      binding.pry
      # client_message.update(thread_id: @response.thread_id)
    end
    
    def self.get_gmail_attribute(gmail_data, attribute)
      headers = gmail_data.payload.headers
      array = headers.reject { |hash| hash.name != attribute }
      array.first.value
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
      
      #Get Message 
      @messageId = service.list_user_histories('me', start_history_id: historyId).history.first.messages.first.id
      @message = service.get_user_message('me', @messageId )
      #set email criteria 
      @user = current_user
      @company = current_user.company
      @threadId = @message.thread_id
      @subject = get_gmail_attribute(@message, "Subject")
      @reciever = get_gmail_attribute(@message, "To")
      @sender = get_gmail_attribute(@message, "From")
    
      # create message for Candidate
      if @sender == @user.email #sent from user
        @msg_present = Message.where(email_id: @messageId).first.present?
        if !@msg_present
          @candidate = Candidate.where(company_id: @company.id, email: @reciever).first 
          
          if @candidate.present? 
            if @message.payload.first.mime_type == "text/plain" 
              @content =  @message.payload.parts.first.body.data.gsub("\r\n", "<br>")
              @content =  @content.gsub("<br><br><br>", "")
            elsif @message.payload.parts.last.mime_type "text/html"
              @content =  @message.payload.parts.last.body.data.gsub("\r\n", "")
              @content =  @content.gsub(/\"/, "")
              @content = @content.split("<div dir=ltr>")[1]
              @content = @content.split("<div class=gmail_extra>")[0]

              @content =  @message.payload.parts.body.data
              @msg = @content
            end
            @msg = @content
            if @candidate.conversation.present?
              Message.create(conversation_id: @candidate.conversation.id, 
                body: @msg, subject: @subject, email_id: @messageId, thread_id: @threadId, 
                user_id: @user.id)
            else 
              Conversation.create(candidate_id: @candidate.id, company_id: @company.id)   
              @conversation = Candidate.find(@candidate.id).conversation
              Message.create(conversation_id: @conversation.id, 
                body: @msg, subject: @subject, email_id: @messageId, thread_id: @threadId, 
                user_id: @user.id)
            end
          else
            return nil
          end
        else
          return nil
        end
      else
        @candidate = Candidate.where(company_id: @company.id, email: @sender).first
        # Get Message Details
        if @candidate.present?
          if @message.payload.parts.last.mime_type == "text/plain" 
            @content =  @message.payload.parts.first.body.data.gsub("\r\n", "<br>")
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
              body: @msg, subject: @subject, email_id: @messageId, thread_id: @threadId, 
              candidate_id: @candidate.id)
          else 
            Conversation.create(candidate_id: @candidate.id, company_id: @company.id)   
            @conversation = Candidate.find(@candidate.id).conversation
            Message.create(conversation_id: @conversation.id, 
              body: @msg, subject: @subject, email_id: @messageId, thread_id: @threadId, 
              candidate_id: @candidate.id)
          end
        else
          return nil
        end
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
end