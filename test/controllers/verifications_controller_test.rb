# frozen_string_literal: true

require 'test_helper'

class VerificationsControllerTest < ActionDispatch::IntegrationTest
  fixtures :items, :companies

  def setup
    @item = items(:one)
    @company = companies(:one)
  end

  test 'go full file on screen' do
    # get "/verifications/go/#{@company.ie}"

    # assert_template :"verifications/go"
    # assert_equal 'go', @controller.action_name
    # assert_equal 'text/html', @response.media_type
    # assert_response 200
    # assert_response :success
  end

  test 'item verification' do
    # get "/verifications/item/#{@item.id}"

    # assert_template :"verifications/item"
    # assert_equal 'item', @controller.action_name
    # assert_equal 'text/html', @response.media_type
    # assert_response 200
    # assert_response :success
  end
end
