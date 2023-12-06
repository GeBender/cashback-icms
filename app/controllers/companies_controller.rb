# frozen_string_literal: true

# == CompaniesController
#
# Companies things
#
class CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import]

  def import
    # Recieve json raw data
    ie = params[:ie]
    path = params[:path]

    ImportJob.perform_later(ie, path)
    render json: {
      ie:,
      path:,
      status: 'ok'
    }
  end

  def import_test
    ie = '283426055'
    path = '/sample-invoices'

    ImportJob.perform_now(ie, path)
    render json: {
      ie:,
      path:,
      status: 'ok'
    }
  end
end
