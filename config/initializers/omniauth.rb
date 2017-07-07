Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
  scope: ['email', 
    'https://www.googleapis.com/auth/gmail.compose',
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/gmail.send'],
    access_type: 'offline'}

  # provider :office365, ENV['OUTLOOK_API_ID'], ENV['OUTLOOK_API_SECRET'], {
  #   scope: ['openid',
  #     'profile',
  #     'User.Read',
  #     'Mail.Read' 
  #   ]
  # }
end
