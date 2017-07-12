module OutlookWrapper
require 'microsoft_graph'

  class Mail
    def get_user_email(access_token)
      callback = Proc.new { |r| r.headers['Authorization'] = "Bearer #{access_token}"}

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                 cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                 &callback)

      me = graph.me
      email = me.user_principal_name
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
    def initialize(current_user)
      configure_client(current_user)
    end

    def configure_client(current_user)
      access_token
    end

    def access_token
      if user.outlook_token.expired?
        user.outlook_token.refresh!
      else
        token = user.outlook_token.token
      end
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


    def self.get_events(token, email)
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{token}"
        r.headers['X-AnchorMailbox'] = email
      end
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)
      @events = graph.me.events.order_by('start/dateTime asc')
    end

    def self.create_event(user, email, dateTime, endTime)
      if user.outlook_token.expired?
        user.outlook_token.refresh!
        token = user.outlook_token.access_token
      else
        token = user.outlook_token.token
      end

      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{user.outlook_token.access_token}"
        r.headers['X-AnchorMailbox'] = email
      end

      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)

      @create = graph.me.events.create(subject: "Pending Interview", 
        body: {content: "Interview with Logan Once he finishes this shit"},
        start: {dateTime: dateTime, timeZone: "America/New_York"}, end: {dateTime: endTime,  timeZone: "America/New_York"}, 
        organizer: {emailAddress: {name: "Logan Houston", address: "houston@talentwiz.com"}})
    end
  end
end