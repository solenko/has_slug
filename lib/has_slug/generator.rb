module HasSlug
  class Generator
    attr_reader :object
    delegate :parent_field_name, :slug_field_name, to: :object


    def initialize(object)
      @object = object
    end

    def generate
      [prefix, I18n.transliterate(object.send(slug_field_name)).parameterize].compact.join('/')
    end

    def prefix
      sluggable_parent.try(:slug) || ''
    end

    def sluggable_parent
      if object.respond_to?(parent_field_name) && (parent = object.send(parent_field_name)) &&
          parent.respond_to?(:slug)
        parent
      end
    end


  end
end