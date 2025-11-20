# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Origen del frontend en producción (Render), se toma de variable de entorno
      origins ENV.fetch("FRONTEND_ORIGIN", "")
  
      resource "*",
        headers: :any,
        methods: [:get, :post, :options],
        credentials: true
    end
  
    allow do
      # Orígenes para entorno de desarrollo (localhost, Vite, etc.)
      origins "http://localhost:3000", "http://localhost:5173"
  
      resource "*",
        headers: :any,
        methods: [:get, :post, :options],
        credentials: true
    end
  end
  