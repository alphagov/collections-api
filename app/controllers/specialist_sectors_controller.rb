class SpecialistSectorsController < ApplicationController
  def show
    presenter = SectorPresenter.new(params[:id])

    if sector_
    render json: presenter.to_json, status: (presenter.empty? ? 404 : 200)
  end

private

  def sector_content
    @sector_content ||= SectorContent.find(@slug)
  end

  def curated_sector
    @curated_sector ||= CuratedSector.find(@slug)
  end
end
