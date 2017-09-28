class OutlookToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  def get_access_token
    token_hash = self.token

    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')

    token = OAuth2::AccessToken.from_hash(client, token_hash)

    if self.expired?
      token = self.refresh!
      # Save new token
      access_token = new_token.token
    else
      access_token = token.token
    end
  end
 
  def refresh!(user)
    refresh_token = user.outlook_token.refresh_token
    access_token = user.outlook_token.access_token

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
    
    user.outlook_token.update_attributes(access_token: token.token, 
      refresh_token: token.refresh_token, 
      expires_at: Time.now + token.expires_in.to_i.seconds) 
  end
 
  def expired?
    expires_at < Time.now
  end
 
  def fresh_token
    refresh! if expired?
    access_token
  end
end