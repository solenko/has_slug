require 'rails/generators'
require "rails/generators/active_record"

class HasSlugGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration

  source_root File.expand_path('../../has_slug', __FILE__)

  def copy_files(*args)
    migration_template 'migration.rb', 'db/migrate/create_has_slug_tables.rb'
  end

end
