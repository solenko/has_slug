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

    it "should defile finder" do
      subject.class.should respond_to(:find_by_slug)
    end

    context "config" do
      it "should raise ArgumentError if slug field not provided" do
        lambda {
          NotSluggedArticle.has_slug
        }.should raise_exception(ArgumentError)

      end

      it "should set slug source field" do
        NotSluggedArticle.has_slug :on => :text
        NotSluggedArticle.slug_field_name.should == :text
      end

      it "should correctly set model_class" do
        subject.class.slug_config.model_class.should == subject.class
      end

      it "should set default enable_history option" do
        subject.class.slug_config.enable_history.should == HasSlug::Config.defaults[:enable_history]
      end

      it "should set default scope" do
        subject.class.slug_config.scope.should == HasSlug::Slug.scoped
      end
    end
  end
  context "slug generation" do
    it "should generate slug for new record on validation" do
      subject.update_attributes(:title => 'test')
      subject.slug.should_not be_empty
    end

    it "should add suffix if slug already exists" do
      subject.update_attributes(:title => 'test')
      second_article = SluggedArticle.create(:title => 'test')
      second_article.slug.should == 'test-1'
    end
  end

  describe "#slug_renew_required?" do

    it "should returns true for new records" do
      subject.title = 'test'
      subject.slug_renew_required?.should be_true
    end

    it "should returns false for object without changes" do
      subject.update_attributes!(:title => 'test')
      subject.slug_renew_required?.should be_false
    end

    it "should returns true for object without changes" do
      subject.update_attributes(:title => 'test')
      subject.title = 'changed attribute'
      subject.slug_renew_required?.should be_true
    end

    it "should returns false it any other attribute changed" do
      subject.update_attributes(:title => 'test')
      subject.text = 'changed attribute'
      subject.slug_renew_required?.should be_false
    end

    it "should returns false it slug updates manually" do
      subject.update_attributes(:title => 'test')
      subject.text = 'changed attribute'
      subject.slug = 'manual slug value'
      subject.slug_renew_required?.should be_false
    end

  end

end
