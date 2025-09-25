class PageController < ApplicationController
  require "./app/api/v1/helpers/auth"
  include Auth
  include PageConcern

  before_action :authenticate!
  def index
    respond_to do |format|
      format.html
      format.json { render json: "Home, sweet home." }
    end
  end
end
