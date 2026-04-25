class ArticlesController < PublicController
  def index
    @articles = Article.published.order(:id)
  end

  def show
    @article = Article.published.find(params[:id])
  end
end
