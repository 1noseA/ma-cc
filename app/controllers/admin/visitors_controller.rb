module Admin
  class VisitorsController < ApplicationController
    def index
      @visitors = Visitor.order(last_visited_at: :desc)
    end

    def show
      @visitor = Visitor.find(params[:id])
    end
  end
end
