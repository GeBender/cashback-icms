# frozen_string_literal: true

require 'test_helper'

class AliquotTest < ActiveSupport::TestCase
  test 'returns newest aliquot with minimum ncm when find' do
    assert_equal 0.17, Aliquot.find_aliquot('1234567890').internal_aliquot
  end
end
