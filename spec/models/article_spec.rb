require "rails_helper"

RSpec.describe Article, type: :model do
  describe "バリデーション" do
    it "title と body が有る場合は有効" do
      expect(build(:article)).to be_valid
    end

    it "title が無い場合は無効" do
      article = build(:article, title: nil)
      expect(article).not_to be_valid
      expect(article.errors[:title]).to be_present
    end

    it "body が無い場合は無効" do
      article = build(:article, body: nil)
      expect(article).not_to be_valid
      expect(article.errors[:body]).to be_present
    end
  end

  describe ".published" do
    it "published: true のレコードだけ返す" do
      published   = create(:article, published: true)
      unpublished = create(:article, published: false)

      expect(Article.published).to include(published)
      expect(Article.published).not_to include(unpublished)
    end
  end
end
