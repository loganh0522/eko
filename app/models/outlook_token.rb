class OutlookToken < ActiveRecord::Base
  belongs_to :user
 
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
 
  def refresh!
    client = OAuth2::Client.new(ENV['OUTLOOK_API_ID'],
                                ENV['OUTLOOK_API_SECRET'],
                                :grant_type => 'refresh_token',
                                :refresh_token => refresh_token,
                                :site => 'https://login.microsoftonline.com',
                                :authorize_url => '/common/oauth2/v2.0/authorize',
                                :token_url => '/common/oauth2/v2.0/token')
    
    token = client.get_token.(client)
    binding.pry
    # token = OAuth2::AccessToken.from_hash(@client)
    token.refresh!

    # update_attributes(
    # access_token: data['access_token'],
    # expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end
 
  def expired?
    expires_at < Time.now
  end
 
  def fresh_token
    refresh! if expired?
    access_token
  end
end