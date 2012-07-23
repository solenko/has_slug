class CreateHasSlugTables < ActiveRecord::Migration
  def self.up
    create_table :slugs do |t|
      t.string :slug
      t.integer :source_object_id
      t.string :source_object_type
    end
    add_index :slugs, :slug

    create_table :slug_history do |t|
      t.string :source
      t.string :destination
    end
    add_index :slug_history, :source
  end

  def self.down
    drop_table :slugs
    drop_table :slug_history


  end

end