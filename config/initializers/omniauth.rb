Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
  scope: ['https://mail.google.com/',
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/calendar'],
    access_type: 'offline'}

  # provider :microsoft_v2_auth, ENV['OUTLOOK_API_ID'], ENV['OUTLOOK_API_SECRET'], {
  #   scope: [ 'openid',
  #            'profile',
  #            'email',
  #            'offline_access',
  #            'https://graph.microsoft.com/User.Read',
  #            'https://graph.microsoft.com/Mail.ReadWrite', 
  #            'https://graph.microsoft.com/Calendars.ReadWrite',
  #             ]
  #            "openid email profile offline_access 
  #            " 
  #            https://graph.microsoft.com/Mail.ReadWrite"
  # }
end
