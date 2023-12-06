# frozen_string_literal: true

require 'test_helper'

class RequestRendererTest < ActiveSupport::TestCase
  def setup
    @dt_ini = '2023-01-01'.to_date
    @dt_fin = '2023-12-31'.to_date

    @request = Request.new(
      company_ie: '000000001',
      start_date: @dt_ini,
      end_date: @dt_fin
    )
  end
end
