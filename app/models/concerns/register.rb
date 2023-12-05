# frozen_string_literal: true

# Block
# methods to work blocks
module Register
  extend ActiveSupport::Concern

  def normalize(
    value: '',
    size: nil,
    string: false,
    decimals: nil,
    required: false,
    force_size: false
  )
    return '' if !required && value.try(:empty?)
    return '' if !required && value.is_a?(Integer) && value.zero?
    return '' if !required && value.is_a?(Float) && value.zero?

    value = normalize_numbers(value, string, decimals)
    value = value.to_s
    float_size = decimals ? (decimals + 1) : 0
    value = value[0..(size + float_size - 1)] if size
    value = value.ljust(size, force_size) if force_size
    value
  end

  def normalize_numbers(value, string, decimals)
    return value unless !string && decimals

    value = value.to_f.round(decimals)
    value = value.to_i if (value.to_f % 1).zero?
    value
  end

  def make_cod_part(doc)
    cod_part_cnpj(doc) || cod_part_cpf(doc)
  end

  def cod_part_cnpj(cnpj)
    false if cpf?(cnpj)
    code_part = ''
    [9, 1, 11, 5, 3, 6, 10, 4, 8, 2, 12, 0, 7, 13].each do |position|
      code_part += (cnpj[position] || '')
    end
    code_part
  end

  def cod_part_cpf(cpf)
    false if cnpj?(cpf)
    code_part = ''
    [7, 3, 9, 2, 1, 8, 4, 0, 6, 5, 10].each do |position|
      code_part += (cpf[position] || '')
    end
    code_part
  end

  def cnpj?(doc)
    doc.size == 14
  end

  def cpf?(doc)
    doc.size == 11
  end

  def render(array, separator = '|')
    array = array.map { |linha| linha.to_s.gsub(separator, ' - ') }
    array.push('').join separator
  end
end
