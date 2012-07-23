require 'spec_helper'
describe HasSlug do
  let(:subject) { SluggedArticle.new }

  describe ".has_slug" do
    it "should add slug attribute" do
      subject.should respond_to(:slug)
    end

    it "should add .slug_config method" do
      subject.class.should respond_to(:slug_config)
    end

    context "config" do
      it "should raise ArgumentError if slug field not provided" do
        lambda {
          NotSluggedArticle.has_slug
        }.should raise_exception(ArgumentError)

      end

      it "should correctly set model_class" do
        subject.class.slug_config.model_class.should == subject.class
      end
    end
  end
end
