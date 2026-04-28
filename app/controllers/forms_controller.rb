class FormsController < PublicController
  def thanks
    @form = Form.find(params[:id])
  end
end
