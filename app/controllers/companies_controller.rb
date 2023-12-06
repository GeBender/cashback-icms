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
    ie = '000000011'
    path = '/home/gebender/Documentos/Cashback/Clientes/Drogabem/Notas/full/2019/02-2019'

    ImportJob.perform_now(ie, path)
    render json: {
      ie:,
      path:,
      status: 'ok'
    }
  end
end
