Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vimeo, ENV['VIMEO_KEY'], ENV['VIMEO_SECRET']
  provider :twitter, "API_KEY", "API_SECRET", scope: "user:email"
end
