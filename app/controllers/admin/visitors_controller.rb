module Admin
  class VisitorsController < ApplicationController
    def index
      @visitors = Visitor.order(last_visited_at: :desc)
    end

    def show
      @visitor = Visitor.find(params[:id])
      @events = @visitor.events.order(occurred_at: :desc)
    end
  end
end
