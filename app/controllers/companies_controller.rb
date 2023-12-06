# frozen_string_literal: true

# == CompaniesController
#
# Companies things
#
class CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import, :save]

  def import
    ie = params[:company_ie]
    path = params[:path]

    ImportJob.perform_later(ie, path)
    render json: {
      ie:,
      path:,
      status: 'ok'
    }
  end

  def save
    save_params = {
      company_ie: params[:company_ie],
      start_date: params[:start_date],
      end_date: params[:end_date],
    }
    SaveJob.perform_later(save_params)
    render json: {
      ie: save_params[:company_ie],
      start_date: save_params[:start_date],
      end_date: save_params[:end_date]
    }
  end

end
