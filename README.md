# HasSlug

Add slug functionality to your ActiveRecord models. Able to handle nested slugs

# Intalation 
 
Add to you Gemfile

`gem 'has_slug', github: 'solenko/has_slug'`

HasSlug store slug to object mapping and slugs history in separate tables.

`rails generate has_slug:install`

will generate migrations for this tables.

# Usage

```
class Category < ActiveRecord::Base
  has_many :children, class_name: 'Category'
  has_many :products
  has_slug on: :name, parent_field_name: :parent
end

class Product < ActiveRecord::Base
  belongs_to :category
  has_slug on: :title, parent_field_name: :category 
end

root = Category.create(name: 'Cell Phones')
root.slug 
=> cell-phones
subcategory = Category.create(name: 'Android Devices', parent: root)
subcategory.slug
=> cell-phones/adnroid-devices
product = Product.create(title: 'Awesome Model', cetegory: subcategory)
product.slug
=> cell-phones/adnroid-devices/awesome-model
```

Gem use I18n.transliterate for slug generation. 
Make sure that you have correct transliteration rules for your language. 
You can use rails-i18n gem or setup your own rules with I18n.backend.store_translations method. 


