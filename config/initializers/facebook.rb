Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'user_friends, user_interests, user_location, email, user_birthday, user_likes', 
           :image_size => 'large'
end