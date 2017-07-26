module OutlookWrapper
  class User
    def self.get_user_email(outlook_token)
      callback = Proc.new { |r| r.headers['Authorization'] = "Bearer #{outlook_token.access_token}"}

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v2.0',
                                 &callback)

      me = graph.me
      
      email = me.user_principal_name
      room = Room.where(email: email).first

      outlook_token.update_attributes(room_id: room.id)
    end
  end

  class Mail
    def self.send_message 
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end

      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{token}"
        r.headers['X-AnchorMailbox'] = email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v2.0',
                                 &callback)

      @create = graph.me.send_mail(
        "message" => {
          "subject" => "TalentWiz Test", 
          "body" => {
            "content_type" => "Text", 
            "content" => "This is clearly working now"
          }, 
          "to_recipients" => [
            {
              "email_address" => {
                "address" => "houston@talentwiz.ca"
              }
            }
          ]
        })
    end

    def self.get_messages(token, email)
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{token}"
        r.headers['X-AnchorMailbox'] = email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      @messages = graph.me.mail_folders.find('inbox').messages.order_by('receivedDateTime desc')
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
        r.headers['X-AnchorMailbox'] = email
      end
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
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
        r.headers['X-AnchorMailbox'] = user.email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                &callback)
      @events = graph.me.events.order_by('start/dateTime asc')
    end

    def self.create_event(user, dateTime, endTime, time)   
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      graph = MicrosoftGraph.new(base_url: 'PATCH https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      @create = graph.me.events.create(subject: "Pending Interview", 
        body: {content: "Interview with Logan Once he finishes"},
        start: {dateTime: dateTime, timeZone: "America/New_York"}, end: {dateTime: endTime,  timeZone: "America/New_York"}, 
        organizer: {emailAddress: {name: "Logan Houston", address: "houston@talentwiz.com"}},
        responseRequested: true, responseStatus: {"@odata.type" => "microsoft.graph.responseStatus"})

      EventId.create(user_id: user.id, event_id: @create.id, interview_time_id: time.id) 
    end

    def self.update_event(user, event, candidate)   
      if user.outlook_token.expired?
        user.outlook_token.refresh!(user)
      end
      
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['Content-Type'] = 'application/json'
        r.headers['X-AnchorMailbox'] = user.email
      end

      path = 'me/events/' + event.event_id
      data = {subject: "Interview with #{candidate.full_name}"}
      
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      graph.service.patch(path, data.to_json)


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
            
    end
  end
end