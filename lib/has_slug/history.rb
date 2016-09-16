module HasSlug
  class History < ActiveRecord::Base
    self.table_name = 'slug_history'
  end
end