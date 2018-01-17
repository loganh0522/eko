module GoogleWrapper 
require 'signet/oauth_2/client'
require 'google/apis/gmail_v1'
require 'google/apis/calendar_v3'
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
        grant_type: 'authorization_code',
        scope: ['email', 
          'https://www.googleapis.com/auth/gmail.compose',
          'https://www.googleapis.com/auth/gmail.modify']
        )
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

      GoogleWorker.perform_in(3.days, current_user.id)
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
        @content = message.payload.parts.last.body.data.gsub("\r\n", "")
        @content = @content.gsub(/\"/, "") 
        @content = @content.gsub("\t", "")
        @content = @content.split("<div id=Signature>")[0].split("<p>")[1..-1].join() if @content.include?("<div id=Signature>")
        @content = @content.split("&lt;<a href=mailto:")[0] if @content.include?("&lt;<a href=mailto:")
        @content = @content.split('</head>')[1] if @content.include?('</head>')
        @content = @content.split('<br>Sent from my iPhone')[0] if @content.include?('<br>Sent from my iPhone')
        @content = @content.split("<div dir=ltr>")[1] if @content.include?("<div dir=ltr>")
        @content = @content.split("<div class=gmail_extra>")[0] if @content.include?("<div class=gmail_extra>")
        @content = @content.split("<div class=gmail_signature")[0] if @content.include?("<div class=gmail_signature")
        @content = @content.split("<div class=gmail_signature")[0] if @content.include?("<div class=gmail_signature")
        @content = @content.gsub("<div>", "<br>").gsub('</div>', "<br>")
        @content = @content.gsub("<br><br><br>", "") if @content.include?("<br><br><br>")
        @msg = @content
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

            if @message.label_ids.include?("DRAFT")
              return nil
            else
              save_message(@message, @messageId, @threadId, @subject, @to, @sender, @company, @user) 
            end
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
            parse_histories_for_messages(@messages, service, current_user)
          end
        elsif @histories.count == 1  
          @messages = @histories.first.messages
          parse_histories_for_messages(@messages, service, current_user)
        end
      end  
      current_user.google_token.update_attributes(history_id: historyId)
    end

    def self.get_message(current_user, messageId)
      self.set_client(current_user)
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = @client

      @message = service.get_user_message('me', messageId)
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
      @service = @client.discovered_api('calendar', 'v3')
    end

    def self.set_client(current_user)
      token = current_user.google_token.access_token
      refresh_token = current_user.google_token.refresh_token

      @client = Signet::OAuth2::Client.new(
        access_token: token, 
        refresh_token: refresh_token, 
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token', 
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth', 
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        grant_type: 'authorization_code')
    end
    
    def self.create_event(event, user, startTime, endTime, time)
      self.set_client(user)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = @client

      event = Google::Apis::CalendarV3::Event.new({
        summary: 'Pending Interview',
        description: event.details,
        attendees: [{email: user.email}],
        location: event.location,
        start: {
          date_time: startTime,
          time_zone: 'America/New_York'
        },
        end: {
          date_time: endTime,
          time_zone: 'America/New_York'
        }, 
      })

      @event = service.insert_event('primary', event)
      EventId.create(user_id: user.id, event_id: @event.id, interview_time_id: time.id) 
    end

    def self.create_event_invite(current_user, startTime, endTime, location, time)
      self.set_client(current_user)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = @client
      
      event = Google::Apis::CalendarV3::Event.new({
        summary: event.title,
        description: event.details,
        attendees: [{email: user.email}],
        location: event.location,
        start: {
          date_time: startTime,
          time_zone: 'America/New_York'
        },
        end: {
          date_time: endTime,
          time_zone: 'America/New_York'
        }, 
      })

      @event = service.insert_event('primary', event, send_notifications: true)
      EventId.create(user_id: user.id, event_id: @event.id, interview_time_id: time.id) 
    end

    def self.get_events(user)
      self.set_client(user)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = @client

      @events = service.list_events('primary')
    end
    
    def self.update_event(user, event, candidate)   
      self.set_client(user)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = @client

      event = service.get_event('primary', event.event_id)
      event.summary = "Interview with #{candidate.full_name}"

      @event = service.update_event('primary', event.id, event)
    end

    def self.destroy_event
    end
  end
end