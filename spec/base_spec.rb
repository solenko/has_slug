require 'spec_helper'
describe HasSlug do
  let(:subject) do
    Class.new(ActiveRecord::Base) do
      include HasSlug
    end
  end

  it "should add slug attribute" do
    subject.should respond_to? :slug
  end
end
