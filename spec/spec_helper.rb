require "has_slug"
require "rubygems"
require "bundler/setup"
require "active_record"
require 'rspec/mocks'
RSpec::Mocks::setup(Object)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :articles do |t|
      t.string :title
      t.string :text
    end

    create_table :categories do |t|
      t.string :name
      t.integer :weight
    end
  end
end

setup_db

class SluggedArticle < ActiveRecord::Base
  self.table_name = 'articles'
  belongs_to :category

  include HasSlug
  has_slug :on => :title

  def parent
    category
  end
end

class NotSluggedArticle < ActiveRecord::Base
  self.table_name = 'articles'
  belongs_to :category
  include HasSlug

  def parent
    category
  end
end

class Category < ActiveRecord::Base
  has_many :slugged_articles
  has_many :not_slugged_articles

  include HasSlug
  has_slug :on => :name


  def children
    articles
  end
end