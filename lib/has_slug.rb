$:.push File.expand_path("../../lib", __FILE__)

module HasSlug
  require 'has_slug/version'
  if defined?(Rails)
    require 'has_slug/engine'
    require 'generators/has_slug/install_generator'
  end

  autoload :Config, 'has_slug/config'
  autoload :History, 'has_slug/history'
  autoload :Slug, 'has_slug/slug'
  autoload :Generator, 'has_slug/generator'
  autoload :Base, 'has_slug/base'

  def self.included(model_class)
    model_class.instance_eval do
      include Base
    end
  end

  def self.extended(model_class)
    model_class.extend Base
  end
end
