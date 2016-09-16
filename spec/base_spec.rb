require 'spec_helper'
describe HasSlug do
  let(:slugged_model) { SluggedArticle.new }
  let(:subject) { slugged_model }

  describe ".has_slug" do
    it "should add slug attribute" do
      expect(subject).to respond_to(:slug)
    end

    it "should add .slug_config method" do
      expect(subject).to respond_to(:slug_config)
    end

    it "should defile finder" do
      expect(subject.class).to respond_to(:find_by_slug)
    end

    context "config" do
      subject { slugged_model.class.slug_config }
      it "should raise ArgumentError if slug field not provided" do
        expect {
          NotSluggedArticle.has_slug
        }.to raise_error(ArgumentError)

      end

      it "should set slug source field" do
        NotSluggedArticle.has_slug :on => :text
        expect(NotSluggedArticle.slug_field_name).to eq(:text)
      end

      it "should correctly set model_class" do
        expect(subject.model_class).to eq(SluggedArticle)
      end

      it "should set default enable_history option" do
        expect(subject.enable_history).to eq(HasSlug::Config.defaults[:enable_history])
      end

      it "should set default scope" do
        expect(subject.scope).to eq(HasSlug::Slug.all)
      end
    end
  end
  context "slug generation" do
    it "should generate slug for new record on validation" do
      subject.update(title: 'test')
      expect(subject.slug).to_not be_empty
    end

    it "should add suffix if slug already exists" do
      subject.update(title: 'test')
      second_article = SluggedArticle.create(title: 'test')
      expect(second_article.slug).to eq('test-1')
    end
  end

  describe "#slug_renew_required?" do

    it "should returns true for new records" do
      subject.title = 'test'
      expect(subject.slug_renew_required?).to be_truthy
    end

    it "should returns false for object without changes" do
      subject.update!(title: 'test')
      expect(subject.slug_renew_required?).to be_falsey
    end

    it "should returns true for object without changes" do
      subject.update(title: 'test')
      subject.title = 'changed attribute'
      expect(subject.slug_renew_required?).to be_truthy
    end

    it "should returns false it any other attribute changed" do
      subject.update(title: 'test')
      subject.text = 'changed attribute'
      expect(subject.slug_renew_required?).to be_falsey
    end

    it "should returns false it slug updates manually" do
      subject.update(title: 'test')
      subject.text = 'changed attribute'
      subject.slug = 'manual slug value'
      expect(subject.slug_renew_required?).to be_falsey
    end

  end

end
