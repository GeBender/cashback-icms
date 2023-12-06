# frozen_string_literal: true

# Definers
# Renderer main module
#
module Definers
  # CodeOperStDefiner
  # Help to define the cod_oper_st value
  #
  module CodOperStDefiner
    extend ActiveSupport::Concern

    def def_cod_oper_st
      return unless entry?
      return 0 if cod_oper_st_zero?
      return 1 if cod_oper_st_one?
      return 2 if cod_oper_st_two?
      return 3 if cod_oper_st_three?

      4
    end

    def cod_oper_st_zero?
      tpNF.zero?
    end

    def cod_oper_st_one?
      return false if cod_oper_st_zero?

      vICMSST? && outside_issuer?
    end

    def cod_oper_st_two?
      return false if cod_oper_st_zero? || cod_oper_st_one?

      vICMSST? && inside_issuer?
    end

    def cod_oper_st_three?
      return false if cod_oper_st_zero? || cod_oper_st_one? || cod_oper_st_two?

      vICMSSTRet?
    end

    def cod_oper_st_four?
      return false if cod_oper_st_zero? || cod_oper_st_one? || cod_oper_st_two? || cod_oper_st_three?

      true
    end

    def cod_oper_st_1_2_4?
      return false unless cod_oper_st_one? || cod_oper_st_two? || cod_oper_st_four?

      true
    end
  end
end
