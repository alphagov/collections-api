class LatestChangesController < ApplicationController
  def show
    presenter = LatestChangesPresenter.new(params[:id])

    render json: presenter.to_json, status: (presenter.empty? ? 404 : 200)
  end
end
