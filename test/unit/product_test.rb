#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
#---
# Excerpted from "Agile Web Development with Rails, 4rd Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(:title       => "My Book Title",
                          :description => "yyy",
                          :image_url   => "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(
      :title => 'My book',
      :description => 'abc',
      :price => 1,
      :image_url => image_url
    )
  end
  
  
  test "image url" do
    ok = %w{fred.gif max.png bob.jpg rob.Jpg al.PnG}
    bad = %w{bob.doc mark.jpg1 mark.jpg/p more.png.more}
    
    ok.each { |name| assert new_product(name).valid? , "#{name} shouldn't be valid" }
    bad.each{ |name| assert new_product(name).invalid?, "#{name} shouldn't be invalid" }
  end

  test "product not valid without unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "yyyy",
                          :price => 1,
                          :image_url => "fred.gif"
                        )
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), 
                product.errors[:title].join('; ')
  end
  
end
