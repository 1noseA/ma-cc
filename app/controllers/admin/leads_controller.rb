module Admin
  class LeadsController < Admin::ApplicationController
    def index
      @leads = Lead.eager_load(:visitor).order("visitors.score DESC")
    end

    def show
      @lead = Lead.includes(visitor: [ :events, :form_submissions ]).find(params[:id])
    end
  end
end
