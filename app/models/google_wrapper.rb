module GoogleWrapper 
require 'signet/oauth_2/client'
require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets.rb'
Google::Apis::RequestOptions.default.retries = 5

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

    def self.set_client(current_user)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token
      @client = Signet::OAuth2::Client.new(access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.compose',
          'https://www.googleapis.com/auth/gmail.modify'],
        grant_type: 'authorization_code')
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
      self.set_client(current_user)
         
      watch_request = Google::Apis::GmailV1::WatchRequest.new
      watch_request.topic_name = 'projects/talentwiz-145409/topics/talentwiz-gcloud'
      watch_request.label_ids = ['INBOX']

      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @client
      @response = service.watch_user('me', watch_request)
      
      current_user.google_token.update_attributes(history_id: @response.history_id)
    end

    def self.send_message(email, id, current_user)
      self.set_client(current_user)
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @client

      message = Google::Apis::GmailV1::Message.new(raw: email.to_s, content_type: "text/html")
      @response = service.send_user_message('me', message)

      @message = Message.find(id)
      @message.update_attributes(email_id: @response.id, thread_id: @response.thread_id)
    end
    
    def self.get_gmail_attribute(gmail_data, attribute)
      headers = gmail_data.payload.headers
      array = headers.reject { |hash| hash.name != attribute }
      array.first.value
    end

    def self.parse_message(message)
      if message.payload.mime_type == "text/plain"
        @content =  message.payload.body.data.gsub("\r\n", "<br>")
        @content =  @content.gsub("<br><br><br>", "")
        @msg = @content
      elsif message.payload.parts.last.mime_type == "text/plain"
        @content =  message.payload.body.gsub("\r\n", "<br>")
        @content =  @content.gsub("<br><br><br>", "")
        @msg = @content       
      elsif message.payload.parts.last.mime_type == "text/html"
        @content =  message.payload.parts.last.body.data.gsub("\r\n", "")
        @content =  @content.gsub(/\"/, "")
        @content = @content.split("<div dir=ltr>")[1]
        @content = @content.split("<div class=gmail_extra>")[0]
        @content = @content.split("<div class=gmail_signature")[0]
        @msg = @content
        # if @content.include?("<div class=gmail_extra>")   
        # else
        #   @content = @content.split("<div id=Signature>")[0].split("<p>")[1..-1].join()
        #   @msg = @content
        # end
      end
    end

    def self.save_message(message, messageId, threadId, subject, to, 
      sender, company, user)
      if sender == user.google_token.email || sender == user.email
        @msg_present = Message.where(email_id: messageId).first.present?
        @candidate = Candidate.where(company_id: company.id, email: to).first      
        if @candidate.present? && !@msg_present
          parse_message(message)
          if @candidate.conversation.present?
            Message.create(conversation_id: @candidate.conversation.id, 
              body: @msg, subject: subject, email_id: messageId, thread_id: threadId, 
              user_id: user.id)
          else 
            Conversation.create(candidate_id: @candidate.id, company_id: company.id)   
            @conversation = Candidate.find(@candidate.id).conversation
            Message.create(conversation_id: @conversation.id, 
              body: @msg, subject: subject, email_id: messageId, thread_id: threadId, 
              user_id: user.id, messageable_type: "Candidate", messageable_id: candidate.id)
          end
        else
          return nil
        end
      else
        @candidate = Candidate.where(company_id: company.id, email: sender).first
        @msg_present = Message.where(email_id: messageId, candidate_id: @candidate.id).first.present?
        
        if @candidate.present? && !@msg_present
          parse_message(message)
          if @candidate.conversation.present?
            Message.create(conversation_id: @candidate.conversation.id, 
              body: @msg, subject: subject, email_id: messageId, thread_id: threadId, 
              candidate_id: @candidate.id)
          else 
            Conversation.create(candidate_id: @candidate.id, company_id: company.id)   
            @conversation = Candidate.find(@candidate.id).conversation
            Message.create(conversation_id: @conversation.id, 
              body: @msg, subject:@subject, email_id: messageId, thread_id: threadId, 
              candidate_id: candidate.id, messageable_type: "Candidate", messageable_id: candidate.id)
          end
        else
          return nil
        end
      end
    end

    def self.parse_histories_for_messages(messages, service, current_user)
      messages.each do |message| 
        @messageId = message.id
        service.get_user_message('me', @messageId) do |res, err|
          if res.present?
            @message = res
            @threadId = @message.thread_id
            @subject = get_gmail_attribute(@message, "Subject")
            if get_gmail_attribute(@message, "To").include?(" <")
              @to = get_gmail_attribute(@message, "To").split('<')[1].split('>')[0]
            else 
              @to = get_gmail_attribute(@message, "To")
            end

            if get_gmail_attribute(@message, "From").include?(" <")
              @sender = get_gmail_attribute(@message, "From").split('<')[1].split('>')[0]
            else
              @sender = get_gmail_attribute(@message, "From")
            end

            @user = current_user
            @company = current_user.company
            save_message(@message, @messageId, @threadId, @subject, @to, @sender, @company, @user) 
          else
            nil
          end
        end
      end
    end

    def self.create_message(historyId, current_user, current_id)
      self.set_client(current_user)
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @client
      #Get Message 
      @histories = service.list_user_histories('me', start_history_id: current_id).history
      
      if @histories != nil
        if @histories.count > 1 
          @histories.each do |history|
            @messages = history.messages
            parse_histories_for_messages(@messages)
          end
        elsif @histories.count == 1  
          @messages = @histories.messages
          parse_histories_for_messages(@messages)
        end
      end
      
      current_user.google_token.update_attributes(history_id: historyId)
    end

    def self.get_messages(current_user)
      self.set_client(current_user)
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @client
      # @histories = service.list_user_histories('me', start_history_id: 329199).history
      # @histories = service.list_user_histories('me', start_history_id: 330582).history
      #   if @histories.count > 1 
      #     @histories.each do |history|
      #       @messages = history.messages
      #       parse_histories_for_messages(@messages, service, current_user)
      #     end
      #   elsif @histories.count == 1  
      #     @messages = @histories.messages
      #     parse_histories_for_messages(@messages, service, current_user)
      #   end
      # end
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

    def self.set_client
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
    end
    
    def self.create_event

      calendar = Calendar::CalendarService.new
      calendar.authorization = user_credentials_for(Calendar::AUTH_CALENDAR)

      event = {
        summary: options[:summary],
        attendees: Array(options[:attendees]).map { |email| { email: email } },
        start: {
          date_time: DateTime.parse(options[:start])
        },
        end: {
          date_time: DateTime.parse(options[:end])
        }
      }

      event = calendar.insert_event('primary', event, send_notifications: true)
      say "Created event '#{event.summary}' (#{event.id})"
    end

    def schedule
      
    end


    def self.update_event
    end
  end
end