module HasSlug
  class Config
    attr_accessor :on
    attr_reader :scope
    attr_accessor :enable_history
    attr_accessor :model_class

    def initialize(config = {})
      set(defaults)
      set(config) if config.any?
    end

    def defaults
      {
          :scope => :global,
          :enable_history => true
      }
    end

    def set(opts = {})
      opts.each_pair do |name, value|
        send("#{name}=", value) if respond_to?("#{name}=")
      end
    end

    def scope=(scope)
      if scope.is_a? Symbol
        @scope = build_scope(scope)
      elsif scope.is_a? ActiveRecord::Relation
        @scope = scope
      else
        raise ArgumentError.new("Scope should be a symbol or ActiveRecord::Relation")
      end
    end

    private
      def build_scope(scope)
        @scope = case scope
                   when :class
                    Slug.where(:source_object_type => model_class.name)
                   when 
                     
                     :base_class
                    Slug.joins("#{model_class.table_name} ON #{model_class.table_name}.#{model_class.primary_key} = #{Slug.table_name}.source_object_id AND #{model_class.inheritance_column} = #{Slug.table_name}.source_object_type")
                   else
                    Slug.scoped
                 end
      end
  end
end