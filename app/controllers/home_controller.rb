class HomeController < ApplicationController
  # T05 で PublicController 継承にリファクタする。
  # それまではこの場所で明示的に認証をスキップする。
  allow_unauthenticated_access all: true

  def show
  end
end
