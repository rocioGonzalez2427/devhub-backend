Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://devhub-frontend-p5lt.onrender.com'  # tu frontend exacto

    resource '*',
      headers: :any,
      expose: ['Authorization'],
      methods: [:get, :post, :options, :delete, :put, :patch],
      credentials: true
  end
end
