module AuthHelper

  SCOPES = [ 'openid',
             'profile',
             'offline_access',
             'User.Read',
             'Mail.ReadWrite',
             'Mail.Send',
             'Calendars.ReadWrite',
             'Calendars.ReadWrite.Shared']

  def get_login_url
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    login_url = client.auth_code.authorize_url(:redirect_uri => authorize_url, :scope => SCOPES.join(' '))
  end

  def get_room_login_url
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    login_url = client.auth_code.authorize_url(:redirect_uri => authorize_room_url, :scope => SCOPES.join(' '))
  end

  def get_room_token_from_code(auth_code)
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
    
    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => authorize_room_url,
                                       :scope => SCOPES.join(' '))
  end


  def get_token_from_code(auth_code)
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
    
    token = client.auth_code.get_token(auth_code,
                                       :redirect_uri => authorize_url,
                                       :scope => SCOPES.join(' '))
  end

  def get_user_email(access_token)
    callback = Proc.new { |r| r.headers['Authorization'] = "Bearer #{access_token}"}

    graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v2.0',
                               cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                               &callback)

    me = graph.me
    email = me.user_principal_name
  end

  def get_access_token
    # Get the current token hash from session
    refresh_token = current_user.outlook_token.refresh_token
    access_token = current_user.outlook_token.access_token
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :grant_type => 'refresh_token',
                                :refresh_token => refresh_token,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
    
    outlook_params = {"client_id" => client.id,
                "client_secret"   => client.secret,
                "grant_type"      => 'refresh_token',
                "refresh_token"   => refresh_token }

    token = client.get_token(outlook_params)
    current_user.outlook_token.update_attributes(access_token: token.token, refresh_token: token.refresh_token, expires_at: Time.now + token.expires_in.to_i.seconds) 
  end
end
