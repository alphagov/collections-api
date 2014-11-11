class SpecialistSectorsController < ApplicationController
  def show
    presenter = SectorPresenter.new(params[:id],
                  start: params[:start],
                  count: params[:count],
                )

    render json: presenter.to_json, status: (presenter.empty? ? 404 : 200)
  end
end
