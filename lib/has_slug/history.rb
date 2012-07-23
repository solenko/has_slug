module HasSlug
  class History < ActiveRecord::Base
    self.table_name = 'slug_history'

    attr_accessible :source, :destination

  end
end