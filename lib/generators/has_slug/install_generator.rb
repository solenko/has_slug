require 'rails/generators'
require "rails/generators/active_record"

module HasSlug
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    desc "Generate migration for slug and slug histiry"
    source_root File.expand_path('../../has_slug', __FILE__)

    def create_migrations(*args)
      migration_template 'templates/migration.rb', "db/migrate/create_has_slug_tables.rb"
    end
  end
end
