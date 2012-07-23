$:.push File.expand_path("../../lib", __FILE__)
module HasSlug
  VERSION = '0.0.1'

  autoload :Config, 'has_slug/config'
  autoload :History, 'has_slug/history'
  autoload :Slug, 'has_slug/slug'
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
