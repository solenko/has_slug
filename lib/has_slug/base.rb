module HasSlug
  module Base
    extend ActiveSupport::Concern


    def slug
      @slug ||= slug_obj.try(:slug)
    end

    def slug=(val)
      attribute_will_change!(:slug) unless @slug == val
      @slug = val
    end

    def slug_changed?
      changed_attributes.include? :slug
    end

    def generate_slug
      prefix = if respond_to?(:parent) && parent
                 self.parent.slug
               end
      self.slug = [prefix, I18n.transliterate(self.send(slug_field_name)).parameterize].compact.join('/')
      ensure_slug_uniqueness
    end

    def ensure_slug_uniqueness
      suffix = 1
      unique_slug = self.slug

      while slug_validation_scope.where(:slug => unique_slug).any? do
        unique_slug = "#{self.slug}-#{suffix}"
        suffix += 1
      end
      self.slug = unique_slug
    end

    def slug_field_name
      self.class.slug_field_name
    end

    def slug_renew_required?
      send(slug_field_name).present? && (slug.blank? || !slug_changed? && send("#{slug_field_name}_changed?"))
    end

    def validate_slug
      errors.add(:slug, :taken) if slug_validation_scope.where(:slug => self.slug).any?
    end

    def update_slug
      self.slug_obj ||= HasSlug::Slug.new
      self.slug_obj.slug = self.slug
      self.slug_obj.save
    end

    def slug_validation_scope
      scope = self.class.slug_config.scope
      scope.where(["id != ?", self.id]) if self.persisted?
      scope
    end

    module ClassMethods
      def has_slug(opts = {}, &block)
        opts.symbolize_keys!.update(:model_class => self)
        raise ArgumentError.new("Pls, specify field (:on option).") unless opts.has_key? :on
        yield slug_config if block_given?
        self.slug_config = opts

        validate :validate_slug
        before_validation :generate_slug, :if => :slug_renew_required?
        after_save :update_slug

        has_one :slug_obj, :as => :source_object, :class_name => 'HasSlug::Slug'
      end

      def slug_config
        @@slug_config ||= Config.new
      end

      def slug_config=(opts)
        slug_config.set(opts)
      end

      def slug_field_name
        slug_config.on
      end

      def find_by_slug(slug)
        joins(:slug_obj).where(:slug_obj => {:slug => slug}).first
      end

    end

  end
end