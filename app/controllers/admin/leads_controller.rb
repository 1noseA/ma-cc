module Admin
  class LeadsController < Admin::ApplicationController
    def index
      @leads = Lead.order(created_at: :desc)
    end

    def show
      @lead = Lead.includes(visitor: [ :events, :form_submissions ]).find(params[:id])
    end
  end
end
