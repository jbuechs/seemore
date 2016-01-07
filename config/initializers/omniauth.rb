Rails.application.config.middleware.use OmniAuth::Builder do
    provider :vimeo, ENV['VIMEO_KEY'], ENV['VIMEO_SECRET']
end
