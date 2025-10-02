module PageConcern
  extend ActiveSupport::Concern

  def headers
    request.headers
  end

  def authenticate!
    respond_to do |format|
      format.html
      format.json { !current_user ? (render json: { error: I18n.t("auth.error.sign_in.invalid_token") }, status: 401) : (render json: "Home, sweet home.") }
    end
  end
end
