class HealthcheckController < ApplicationController

  def index
    render json: {
      status: service_status
    }
  end

private

  def service_status
    check_content_api
    check_content_store
    "ok"
  rescue GdsApi::HTTPErrorResponse
    "critical"
  end

  def check_content_api
    CollectionsAPI.services(:content_api).sections
  end

  def check_content_store
    CollectionsAPI.services(:content_store).content_item('/does/not/exist')
  end
end
