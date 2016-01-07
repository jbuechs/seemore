Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vimeo, ENV['VIMEO_KEY'], ENV['VIMEO_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
