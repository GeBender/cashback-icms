# frozen_string_literal: true

require 'test_helper'

class RegisterTest < ActiveSupport::TestCase
  def setup
    @block = Company.new
  end

  test 'fake random cnpj' do
    assert_equal '17934139891', @block.cod_part_cpf('94373981191')
    assert_equal '82872140779', @block.cod_part_cpf('02724778189')
  end

  test 'fake random cpf' do
    assert_equal '05025113044442', @block.cod_part_cnpj('45453214001042')
    assert_equal '08142701080063', @block.cod_part_cnpj('08821476000103')
  end

  test 'must know what is a CPF and what is a CNPJ' do
    assert_equal true, @block.cnpj?('45453214001042')
    assert_equal false, @block.cnpj?('94373981191')

    assert_equal true, @block.cpf?('94373981191')
    assert_equal false, @block.cpf?('45453214001042')
  end

  test 'normalize requireds' do
    assert_equal '0', @block.normalize(value: '0', required: true)
    assert_equal '0', @block.normalize(value: 0, required: true)
    assert_equal '', @block.normalize(value: 0, required: false)
    assert_equal '', @block.normalize(value: nil, required: false)
    assert_equal '', @block.normalize(value: nil, required: true)
  end

  test 'normalize size' do
    assert_equal 'abcde', @block.normalize(value: 'abcdefgh', string: true, size: 5)
  end
  test 'normalize decimals' do
    assert_equal '1.12345', @block.normalize(value: 1.123451234, decimals: 5)
    assert_equal '221.123', @block.normalize(value: 221.123, decimals: 3, size: 3)
    assert_equal '1', @block.normalize(value: 1.0, decimals: 5)
  end

  test 'render simple data' do
    assert_equal 'a|b|c|d|e|', @block.render(%w[a b c d e])
  end

  test 'render simple data changing separator' do
    assert_equal 'a;b;c;d;e;', @block.render(%w[a b c d e], ';')
  end

  test 'render data removing separator from strings' do
    assert_equal 'a|b|c|d|e - f|', @block.render(%w[a b c d e|f])
  end

  test 'normalize with force size something' do
    assert_equal 'abcdexxxxx', @block.normalize(value: 'abcde', size: 10, force_size: 'x')
  end
end
