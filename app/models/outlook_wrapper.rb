module OutlookWrapper
  class User
    def self.get_user_email(outlook_token)
      
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      callback = Proc.new { |r| r.headers['Authorization'] = "Bearer #{outlook_token.access_token}"}

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      me = graph.me
      
      email = me.user_principal_name

      room = Room.where(email: email).first
      outlook_token.update_attributes(room_id: room.id)
    end

    def self.set_room_token(outlook_token)
      callback = Proc.new { |r| r.headers['Authorization'] = "Bearer #{outlook_token.access_token}"}

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      email = graph.me.user_principal_name
      @room = Room.where(email: email).first
      
      if @room.present? 
        outlook_token.update_attributes(room_id: @room.id)
      else 
        nil 
      end
    end

    def self.create_subscription(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      @token = user.outlook_token.access_token
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{@token}"
        r.headers['Content-Type'] = 'application/json'
      end

      path = 'subscriptions'
      
      data = {
        changeType: "created",
        notificationUrl: ENV['OUTLOOK_WEBHOOK'],
        resource: "me/mailFolders('Inbox')/messages",
        resource: "me/mailFolders('SentItems')/messages",
        expirationDateTime: Time.now + 4230.minutes,
        clientState: "talentWiz-graph-state"
      }
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)


      @response = graph.service.post(path, data.to_json)

      user.outlook_token.update_attributes(subscription_id: @response['id'],  subscription_expiration: @response["expiration_date_time"])
      
      OutlookWorker.perform_in(54.hours, user.id)
    end

    def self.update_subscription(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      @token = user.outlook_token.access_token
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{@token}"
        r.headers['Content-Type'] = 'application/json'
      end

      path = "subscriptions/#{user.outlook_token.subscription_id}"
      
      data = {
        expirationDateTime: Time.now + 4230.minutes,
      }
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @response = graph.service.patch(path, data.to_json)

      user.outlook_token.update_attributes(subscription_id: @response['id'],  subscription_expiration: @response["expiration_date_time"])
    end

    def self.destroy_subscription(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      @token = user.outlook_token.access_token
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{@token}"
        r.headers['Content-Type'] = 'application/json'
      end

      path = "subscriptions/#{user.outlook_token.subscription_id}"
      
      data = {
        expirationDateTime: Time.now + 4230.minutes,
      }
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      graph.service.delete(path)
    end
  end

  class Mail
    def self.send_message(user, msgId, subject, body, recipient_email)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end


      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @create = graph.me.send_mail(
        "message" => {
          "subject" => subject, 
          "body" => {
            "content_type" => "HTML", 
            "content" => body
          }, 
          "to_recipients" => [
            {
              "email_address" => {
                "address" => recipient_email
              }
            }
          ]
        })


      @response = graph.me.mail_folders.find('SentItems').messages.first
      @message = Message.find(msgId)
      @message.update_attributes(email_id: @response.id, thread_id: @response.conversation_id)
    end

    def self.get_messages(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['X-AnchorMailbox'] = user.email
        r.headers['Content-Type'] = 'application/json'
      end


      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      # @message = graph.me.mail_folders.find('inbox').messages.first.body.content
      # graph.me.messages.find(id)
    end

    def self.create_message_object_from_outlook(subId, msgId)
      @user = OutlookToken.where(subscription_id: subId).first.user
      
      if @user.outlook_token.expired?
        @user.outlook_token.refresh!(@user)
      end

      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{@user.outlook_token.access_token}"
        r.headers['X-AnchorMailbox'] = @user.email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)
      

      @message = graph.me.messages.find(msgId)
      if @message.present?
        @subject = @message.subject
        @threadId = @message.conversation_id
        @user_email = graph.me.user_principal_name
        @company = @user.company
        @sender = @message.sender.email_address.address
        
        if @sender == @user_email #sent from user
          @msg_present = Message.where(email_id: msgId).first.present?
          
          if !@msg_present
            @recipient = @message.to_recipients.first.email_address.address
            @candidate = Candidate.where(company_id: @company.id, email: @recipient).first 
            
            if @candidate.present? 
              if @message.body.content_type == "text"
                @content = @message.body.content.gsub("\r\n", "<br>")
                @content = @message.body.content.gsub("<br><br><br>", "")
              else
                @content =  @message.body.content.gsub("\r\n", "")
                @content = @content.gsub(/\"/, "")
                @content = @content.gsub("\t", "")
                @content = @content.split("<div id=Signature>")[0].split("<p>")[1..-1].join()
              end
              
              @msg = @content

              if @candidate.conversation.present?
                Message.create(conversation_id: @candidate.conversation.id, 
                  body: @msg, subject: @subject, email_id: msgId, thread_id: @threadId, 
                  user_id: @user.id)
              else 
                Conversation.create(candidate_id: @candidate.id, company_id: @company.id)   
                @conversation = Candidate.find(@candidate.id).conversation
                Message.create(conversation_id: @conversation.id, 
                  body: @msg, subject: @subject, email_id: msgId, thread_id: @threadId, 
                  user_id: @user.id)
              end
            else
              return nil
            end
          else
            return nil
          end
        else #sent from Candidate
          @recipient = @message.sender.email_address.address
          @candidate = Candidate.where(company_id: @company.id, email: @recipient).first
          
          if @candidate.present?  
            if @message.body.content_type == "text"
              @content = @message.body.content.gsub("\r\n", "<br>")
              @content = @message.body.content.gsub("<br><br><br>", "")
            else
              @content =  @message.body.content.gsub("\r\n", "")
              @content = @content.gsub(/\"/, "")
              
              if @content.include?("<div class=gmail_extra>") 
                @content = @content.split("<div dir=ltr>")[1]
                @content = @content.split("<div class=gmail_extra>")[0]
                @msg = @content
              else
                @content = @content.split("<div id=Signature>")[0].split("<p>")[1..-1].join()
                @msg = @content
              end
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
      else
        head 200
      end
    end
  end

  class Calendar
    attr_reader :error_message, :response

    def initialize(options={})
      initialize(response, options{})
    end

    def self.get_meeting_times(user, token, email)
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{token}"
        r.headers['Content-type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = email
      end
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      @meetingTimes = graph.me.find_meeting_times(meetingDuration: "PT1H")
    end

    def access_token(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!
      else
        token = user.outlook_token.token
      end
    end

    def self.get_events(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/', cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'), &callback)

      @events = graph.me.events.order_by('start/dateTime asc')
    end

    def self.create_event(event, user, dateTime, endTime, time)   
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)
      if user.class == Room 
        @create = graph.me.events.create(subject: "Pending Interview", 
          body: {content: event.details},
          start: {dateTime: dateTime, timeZone: "America/New_York"}, end: {dateTime: endTime,  timeZone: "America/New_York"}, 
          organizer: {emailAddress: {address: user.email}})

        EventId.create(room_id: user.id, event_id: @create.id, interview_time_id: time.id) 
      else
        @create = graph.me.events.create(subject: "Pending Interview", 
          body: {content: event.details},
          start: {dateTime: dateTime, timeZone: "America/New_York"}, end: {dateTime: endTime,  timeZone: "America/New_York"}, 
          organizer: {emailAddress: {name: user.full_name, address: user.email}})
        
        EventId.create(user_id: user.id, event_id: @create.id, interview_time_id: time.id) 
      end
    end

    def self.create_event_invite(interview, user, dateTime, endTime, attendee)   
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      @create = graph.me.events.create(subject: interview.title, 
        body: {content: interview.notes},
        start: {dateTime: dateTime.strftime("%Y-%m-%dT%H:%M:%S"), timeZone: "America/New_York"}, end: {dateTime: endTime.strftime("%Y-%m-%dT%H:%M:%S"),  timeZone: "America/New_York"}, 
        organizer: {emailAddress: {name: user.full_name, address: user.email}},
        attendees: [{emailAddress: {address: attendee.email, name: attendee.full_name}, type: "required"}],
        responseRequested: interview.send_request)
    end

    def self.update_event(user, event, candidate, interview)   
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-Type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      path = 'me/events/' + event.event_id
      data = {subject: "Interview with #{candidate.full_name}",
              body: {content: interview.notes},
              responseStatus: {response: "Accepted", time: Time.now},
              attendees: [
                { status: { response: "Accepted", time: Time.now},
                emailAddress: { address: user.email, name: user.full_name }},
                {status: {response: "Accepted", time: Time.now}, 
                emailAddress: { address: candidate.email, name: candidate.full_name }}
              ]}
              

      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      graph.service.patch(path, data.to_json) 
    end

    def self.destroy_event(user, event)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-Type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      path = 'me/events/' + event.event_id
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      graph.service.delete(path)
    end

    def self.find_meeting_times(user)
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-Type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      path = 'me/findMeetingTimes'
      
      data = { 
        isOrganizerOptional: "true",
        attendees:[
          { 
            type: "required",  
            emailAddress: { 
              name: "Logan Houston",
              address: "talentwiz@outlook.com" 
            } 
          }],  
        timeConstraint: {
          activityDomain: "work",
          timeslots:[  
            { 
              start: { 
                dateTime: "2017-08-04T09:00:00",  
                timeZone: "Pacific Standard Time"
              },  
              end: { 
                dateTime: "2017-08-05T17:00:00",  
                timeZone: "Pacific Standard Time"
              } 
            }
          ] 
        },  
        meetingDuration: "PT1H",
        returnSuggestionReasons: "true",
        minimumAttendeePercentage: "100"
      }
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/beta/',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)
      
      graph.service.post(path, data.to_json) 


    end
  end
end


# #outlook
# if @message.body.content_type == "text"
# else
#   ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find(id)
#     .body.content).split("Hey TalemtWiz Room")[0]
# end
#inbox emails 
# msg =  msg.gsub("\r\n", "")
# msg = msg.gsub(/\"/, "")
# if msg.include?("<div class=gmail_extra>") 
# msg = msg.split("<div dir=ltr>")[1]
# msg = msg.split("<div class=gmail_extra>")[0]
# "<div>" + msg
# else
# msg = msg.split("<div id=Signature>")[0].split("<p>")[1..-1].join()
# "<p>" + msg
# end


# sent emails
# if @message.content_type == "text"
# else 
# msg = msg.gsub("\r\n", "")
# msg = msg.gsub(/\"/, "")
# msg = msg.gsub("\t", "")
# msg = msg.split("<p>")[1..-2].join()
#  "<p>" + msg

#graph.service.delete('subscriptions/dbc3532d-df27-46ac-b28e-1d21099abc9a')


# @create = graph.me.send_mail(
#   "message" => {
#     "subject" => "TalentWiz Test", 
#     "body" => {
#       "content_type" => "Text", 
#       "content" => "This is clearly working now"
#     }, 
#     "to_recipients" => [
#       {
#         "email_address" => {
#           "address" => "houston@talentwiz.ca"
#         }
#       }
#     ]
#   })

# @create = graph.me.messages.create(
#   {
#     "subject" => "TalentWiz Test", 
#     "body" => {
#       "content_type" => "Text", 
#       "content" => "This is clearly working now"
#     }, 
#     "to_recipients" => [
#       {
#         "email_address" => {
#           "address" => "houston@talentwiz.ca"
#         }
#       }
#     ]
#   })


# graph.me.mail_folders.find('SentItems').messages.first
# graph.me.mail_folders.find('SentItems').messages.first.conversation_id
# id1 graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH2AAAA").body.content.split("dir=\"ltr\">")[1].split('</div>')[0]
# id2 graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH3AAAA").body.content.split("dir=\"ltr\">")[1].split('</div>')[0]
# id3 graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH4AAAA").body.content.split("dir=\"ltr\">")[1].split('</div>')[0]
# id4 graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH5AAAA").body.content.split("dir=\"ltr\">")[1].split('</div>')[0]
# ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH3AAAA").body.content)
# ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH5AAAA").body.content)
# dad-hockley "AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjIAAAE="
# email-mom ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjH-AAAA").body.content)

# ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA1rjIAAAE=").body.content)


# send from outlook
# ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find('inbox').messages.first.body.content)

# @message.body.content.split("dir=\"ltr\">")[1].split('</div>')[0]
# @messages = graph.me.mail_folders.find('inbox').messages.order_by('receivedDateTime desc')
# ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find("AQMkADAwATM3ZmYAZS0wYTU1AC1hMjUwLTAwAi0wMAoARgAAAy908hwkDTxDkvZE3tUY1rAHAEof28m476pIpdF3oXTde94AAAIBDAAAAEof28m476pIpdF3oXTde94AAAA7rA2VAAAA").body.content.split("Hey Logan")[0]).split("On" + date)[0]
#gmail
# if @message.content_type == "text"
#   @message.body.content.split("Hey Logan")[0].split("Sent from")[0]
# else
#   ActionView::Base.full_sanitizer.sanitize(graph.me.messages.find(id).body.content.split("Hey Logan")[0]).split("On " + date)[0]
# Get Email Address @message.to_recipients.first.email_address
# end

# msg.split("<html><head><meta http-equiv= Content-Type  content= text/html; charset=utf-8 ><meta content= text/html; charset=iso-8859-1 ><style type= text/css  style= display:none ><!--p\t{margin-top:0;\tmargin-bottom:0}--></style></head><body dir= ltr ><div id= divtagdefaultwrapper  dir= ltr  style= font-size:12pt; color:#000000; font-family:Calibri,Helvetica,sans-serif >")[1]
# msg.split("<div id= Signature >")[0]
# msg.gsub("</body>", "")
# msg.gsub("<body>", "")
# msg.gsub("</html>", "")
