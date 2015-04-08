#Rails.application.config.middleware.use OmniAuth::Builder do  
#  provider :twitter, 't7r7s4JjOP513tSMNr0g', '8LrrHAE6zEw7qPWpm6B9T6Nm3kPeawcyvl2XSWL50A'  
#  provider :facebook, '130687390342032', '67f4333ef08bd2bff04e45d9e1efff50', {:scope => 'publish_stream,offline_access,email'}
#end
Twitter.configure do |config|
  config.consumer_key = 't7r7s4JjOP513tSMNr0g'
  config.consumer_secret = '8LrrHAE6zEw7qPWpm6B9T6Nm3kPeawcyvl2XSWL50A'
  config.oauth_token = '312458956-e2BaxI3jtlXCU5I4WPIrhrl2ejGTTKOgJbLL5Xpi'
  config.oauth_token_secret = 'zTS0OwblbYU5XnjSOUFFeQk2SaZ8JLodzDJPaIsTUfo'
end
