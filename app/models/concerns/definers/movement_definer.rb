# frozen_string_literal: true

# Definers
# Definers main module
#
module Definers
  # MovementRenderer
  # Help to render the movement lines
  #
  # rubocop:disable Metrics/ModuleLength
  module MovementDefiner
    extend ActiveSupport::Concern
    include Register

    # 2
    def def_cod_part
      return unless doc_part

      make_cod_part(doc_part)
    end

    # 8
    def def_tipo_oper
      return 'EI' if initial?
      return 'EN' if buy?
      return 'SD' if sale?
      return 'EF' if final?
    end

    # Entries values
    # 13
    def def_qtd_entrada
      return 0 unless entry? || final?

      qTrib * fat_conv
    end

    # 14
    def def_valor_unit_ent
      return unless entry?

      ((vUnTrib / fat_conv) - (vDesc.to_f / def_qtd_entrada))
    end

    def valor_unit_ent_all
      ((vUnTrib / fat_conv) - (vDesc.to_f / def_qtd_entrada))
    end

    # 15
    def def_valor_tot_ent
      return 0 unless entry?

      (def_qtd_entrada * def_valor_unit_ent)
    end

    # 16
    def def_aliq_op_prop
      return pICMS.to_f / 100 if pICMS.to_f.positive?
      return 0.17 if pmc?
      return aliquot if aliquot?

      0
    end

    # 17
    def def_bc_op_prop
      return 0 if cod_oper_st_zero? || cod_oper_st_three?

      vBC.to_f.positive? ? vBC.to_f : def_valor_tot_ent
    end

    # TODO: TEST CASE 3
    # 18
    def def_icms_op_prop
      return 0 if cod_oper_st_zero?
      return (def_aliq_op_prop * def_bc_op_prop) if cod_oper_st_1_2_4?
      return ((def_bc_icms_st * def_aliq_icms_st) - def_icms_st) if cod_oper_st_three?
      # Old invoice value: # vICMS
    end

    # 19
    def def_icms_unit_op_prop
      return 0 if def_qtd_entrada.zero?

      def_icms_op_prop / def_qtd_entrada
    end

    # 20
    def def_icms_fecomp
      return vFCPST.to_f if cod_oper_st_one? || cod_oper_st_two?
      return vFCPSTRet.to_f if cod_oper_st_three?

      0
    end

    # ICMS ST values
    # 21
    def def_bc_icms_st
      return bc_pmc if pmc? && (invoice_icms_st.zero? || cod_oper_st_three?)
      return bc_mva if mva? && (invoice_icms_st.zero? || cod_oper_st_three?)
      return vBCST.to_f if cod_oper_st_one? || cod_oper_st_two?

      # return vBCSTRet.to_f if cod_oper_st_three?

      # TODO: Review, isso ou zero quando não tem os dados na nota?
      # 0
      def_valor_tot_ent
    end

    # 22
    def def_bc_unit_icms_st
      return 0 if def_qtd_entrada.zero?

      (def_bc_icms_st / def_qtd_entrada)
    end

    # 23
    def def_aliq_icms_st
      return (pICMSST.to_f / 100) if (cod_oper_st_one? || cod_oper_st_two?) && pICMSST?
      return (pST.to_f / 100) if cod_oper_st_three? && pST?
      return 0.17 if pmc?
      return aliquot if aliquot?

      0
    end

    # 24
    def def_icms_st
      return (bc_pmc * def_aliq_icms_st) if pmc? && invoice_icms_st.zero?

      invoice_icms_st
    end

    # 25
    def def_valor_icms_sup
      return 0 if cod_oper_st_zero?
      return (def_icms_st + def_icms_op_prop + def_icms_fecomp) if cod_oper_st_one? || cod_oper_st_two?
      return ((def_bc_icms_st * def_aliq_icms_st) + def_icms_fecomp) if cod_oper_st_three? || cod_oper_st_four?
    end

    # 26
    def def_valor_uni_icms_sup
      return  0 if def_qtd_entrada.zero?

      def_valor_icms_sup / def_qtd_entrada
    end

    # 27
    def def_origem_inf
      return 0 if cod_oper_st_zero?
      return 1 if cod_oper_st_one? || cod_oper_st_two?
      return 2 if cod_oper_st_three?
      return 3 if cod_oper_st_four?
    end

    # Sales values
    # 30
    def def_cod_enq_saida
      return 2 if self.CFOP == '5927'
      return 3 if self.CST.to_s[0] == '4'
      return 4 if outside_issuer?
      return 0 if state_taxpayer_issuer?

      1
    end

    # 31
    def def_qtd_saida
      return 0 unless sale? || final?

      qTrib
    end

    def def_valor_unit_saida = (vUnTrib - (vDesc.to_f / def_qtd_saida))

    # 33
    def def_valor_saida = (def_valor_unit_saida * qTrib)

    # 34
    def def_aliq_icms_efetiva
      result = ((pICMS.to_f / 100) + def_icms_fecomp)
      return 0 if def_cod_enq_saida.zero?
      return result if result.positive?
      return 0.17 if pmc?
      return aliquot if aliquot?

      0
    end

    # 35
    def def_icms_efetivo = (def_valor_saida * def_aliq_icms_efetiva)

    # 36
    def def_icms_prop_unit_transp
      return 0 unless sale? && def_cod_enq_saida.positive?

      last_icms_prop.to_f
    end

    # 37
    def def_icms_prop_transp = (def_icms_prop_unit_transp * def_qtd_saida)

    # 38
    def def_bc_unit_icms_sup_transp
      return 0 unless sale? && def_cod_enq_saida.positive?

      last_saldo_bc.to_f
    end

    # 39
    def def_bc_icms_sup_transp = (def_bc_unit_icms_sup_transp * def_qtd_saida)

    # 40
    def def_valor_unit_icms_sup_transp = (def_bc_unit_icms_sup_transp * def_aliq_icms_efetiva)

    # 41
    def def_valor_icms_sup_transp_cf
      return 0 unless def_cod_enq_saida == 1

      valor_icms_st_transp
    end

    # 42
    # TODO: CONFIRM MANUAL DIFF FROM EXCEL (REGIME == 2) AND icms_prop_transp SUBTRACTION
    def def_valor_icms_st_transp_fgn
      return 0 unless def_cod_enq_saida == 2

      valor_icms_st_transp - def_icms_prop_transp
    end

    # 43
    def def_valor_icms_st_transp_isen
      return 0 unless def_cod_enq_saida == 3 && def_valor_saida <= valor_icms_st_transp

      valor_icms_st_transp - def_icms_prop_transp
    end

    # 44
    # TODO: HERE REGIME IS ALWAYS 1
    def def_valor_icms_sup_transp_uf
      return 0 unless def_cod_enq_saida == 4

      regime == 1 ? (valor_icms_st_transp - def_icms_prop_transp) : (def_qtd_saida * def_valor_unit_icms_sup_transp)
    end

    # 45
    def def_qtd_estoque
      return last_estoque || 0 if final?

      stock.positive? ? stock : 0
    end

    # 46
    # TODO: TESTS
    def def_icms_prop_unit_estoque
      buy = avarage_transp(last_icms_prop.to_f, def_icms_unit_op_prop)
      sale = last_icms_prop.to_f
      transport_calc(def_icms_unit_op_prop, buy, sale)
    end

    # 47
    # TODO: TESTS
    def def_saldo_bc_unit_icms_sup
      return last_saldo_bc || 0 if final?

      buy = avarage_transp(last_saldo_bc.to_f, def_bc_unit_icms_st)
      sale = last_saldo_bc.to_f
      transport_calc(def_bc_unit_icms_st, buy, sale)
    end

    # 48
    # TODO: MANUAL DIFF FROM EXCEL
    # TODO: TESTS
    def def_saldo_icms_sup
      # return def_valor_icms_sup if ei?
      def_qtd_estoque * def_saldo_icms_unit_sup
    end

    # 49
    # TODO: MANUAL DIFF FROM EXCEL
    # TODO: TESTS
    def def_saldo_icms_unit_sup
      return last_saldo_unit || 0 if final?

      buy = avarage_transp(last_saldo_unit.to_f, def_valor_uni_icms_sup)
      sale = last_saldo_unit.to_f
      transport_calc(def_valor_uni_icms_sup, buy, sale)
    end

    # 50
    def def_apur_ressarc
      return sum_ressarc || 0 if final?
      return 0 if last_estoque.to_f.zero?

      comparative.positive? && def_saldo_bc_unit_icms_sup.positive? ? comparative.round(2) : 0
    end

    # 51
    def def_apur_compl
      return sum_compl || 0 if final?
      return 0 if last_estoque.to_f.zero?

      comparative.negative? && def_saldo_bc_unit_icms_sup.positive? ? -comparative.round(2) : 0
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
