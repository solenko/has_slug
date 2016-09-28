module HasSlug
  class UrlRewriter

    include ActionDispatch::Routing::PolymorphicRoutes
    include Rails.application.routes.url_helpers

    DEFAULT_BYPASS_URLS = [
      /\/assets\//
    ]
    
    attr_reader :options

    def initialize(app, options = {})
      @app = app
      @options = HashWithIndifferentAccess.new(options)
    end
    
    def only
      options.fetch(:only, [])     
    end
    
    def except
      options.fetch(:except, DEFAULT_BYPASS_URLS)
    end

    def call(env)
      unless bypass?(env['PATH_INFO'])
        path = env['PATH_INFO'].gsub(/\/$/, '')
        object = Slug.where(slug: path).includes(:source_object).first.try(:source_object)
        env['PATH_INFO'] = polymorphic_path(object) if object
      end
      @app.call(env)
    end

    private

    def bypass?(path)
      (only.any? && !only.any? { |regexp| path =~ regexp}) || 
      except.any? { |regexp| path =~ regexp }
    end

    def allowed_methods
      ALLOWED_METHODS
    end
  end
end