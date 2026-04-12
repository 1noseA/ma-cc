class ArticlesController < ApplicationController
  # T05 で PublicController 継承にリファクタする。
  # それまではこの場所で明示的に認証をスキップする。
  allow_unauthenticated_access all: true

  def index
    @articles = Article.published.order(:id)
  end

  def show
    @article = Article.published.find(params[:id])
  end
end
