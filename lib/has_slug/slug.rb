module HasSlug
  class Slug < ActiveRecord::Base
    belongs_to :source_object, :polymorphic => true

    after_update :keep_history

    private
      def keep_history
        return unless source_object.class.slug_config.enable_history
        return unless slug_changed?
        source, destination = changes['slug']
        History.create(:source => source, :destination => destination)
        History.where({:destination => destination}).update_all({:destination => source})
      end
  end
end