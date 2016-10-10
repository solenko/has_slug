module HasSlug
  module Base
    extend ActiveSupport::Concern

    included do
      class_attribute :slug_config
    end


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

    def regenerate_slug!
      generate_slug
      update_slug
    end

    def generate_slug
      self.slug = HasSlug::Generator.new(self).generate
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

    def parent_field_name
      self.class.parent_field_name
    end

    def children_field_names
      self.class.children_field_names
    end

    def slug_renew_required?
      send(slug_field_name).present? && (slug.blank? || !slug_changed? && send("#{slug_field_name}_changed?"))
    end

    def validate_slug
      errors.add(:slug, :taken) if slug_validation_scope.where(:slug => self.slug).any?
    end

    def update_slug
      build_slug_obj unless self.slug_obj
      self.slug_obj.slug = self.slug
      transaction do
        self.slug_obj.save
        children_field_names.each do |field_name|
          Array(send(field_name)).each do |record|
            record.regenerate_slug!
          end
        end
      end

    end

    def slug_validation_scope
      scope = self.class.slug_config.scope
      scope = scope.where.not(source_object_id: id, source_object_type: self.class.name) if self.persisted?
      scope
    end

    module ClassMethods

      def has_slug(opts = {}, &block)
        opts.symbolize_keys!.update(:model_class => self)
        raise ArgumentError.new("Pls, specify field (:on option).") unless opts.has_key? :on
        self.slug_config = Config.new(opts)
        yield slug_config if block_given?

        validate :validate_slug
        before_validation :generate_slug, :if => :slug_renew_required?
        after_save :update_slug

        has_one :slug_obj, :as => :source_object, :class_name => 'HasSlug::Slug'
        self.slug_config
      end

      delegate :parent_field_name, :children_field_names, to: :slug_config

      def slug_field_name
        slug_config.on
      end

      def find_by_slug(slug)
        joins(:slug_obj).where(:slug_obj => {:slug => slug}).first
      end
    end

  end
end