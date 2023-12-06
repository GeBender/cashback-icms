# frozen_string_literal: true

# Renderers
# Renderer main module
#
module Renderers
  # MovementRenderer
  # Help to render the movement lines
  #
  module MovementRenderer
    extend ActiveSupport::Concern
    include Register

    class_methods do
      def headers
        %w[
          reg cod_part cod_item descr_item data chave_acesso cupom_fiscal tipo_oper cfop cst cod_oper_st cod_ean
          qtd_entrada valor_unit_ent valor_tot_ent aliq_op_prop bc_op_prop icms_op_prop icms_unit_op_prop icms_fecomp
          bc_icms_st bc_unit_icms_st aliq_icms_st icms_st valor_icms_sup valor_uni_icms_sup origem_inf daems gnre
          cod_enq_saida qtd_saida valor_unit_saida valor_saida aliq_icms_efetiva icms_efetivo icms_prop_unit_transp
          icms_prop_transp bc_unit_icms_sup_transp bc_icms_sup_transp valor_unit_icms_sup_transp
          valor_icms_sup_transp_cf valor_icms_st_transp_fgn valor_icms_st_transp_isen valor_icms_sup_transp_uf
          qtd_estoque icms_prop_unit_estoque saldo_bc_unit_icms_sup saldo_icms_sup saldo_icms_unit_sup apur_ressarc
          apur_comp
        ]
      end
    end

    # Initital values
    # 1
    def reg = '2000'

    # 2
    def cod_part
      normalize(value: def_cod_part, string: true, size: 60) unless final?
    end

    # 3
    def cod_item = normalize(value: cProd, string: true, size: 60, required: true)

    # 4
    def descr_item = normalize(value: xProd, string: true, size: 60, required: true)

    # 5
    def data = normalize(value: invoice_date.strftime('%Y%m%d'), size: 8, required: true)

    # 6
    def chave_acesso
      normalize(value: invoice_key, size: 44, force_size: '0', required: true) unless final?
    end

    # 7
    def cupom_fiscal = ''

    # 8
    def tipo_oper = normalize(value: def_tipo_oper, size: 2, string: true, required: true)

    # 9
    def cfop = (normalize(value: self.CFOP, size: 4) unless final?)

    # 10
    def cst = (normalize(value: self.CST, size: 3) unless final?)

    # 11
    def cod_oper_st = (normalize(value: def_cod_oper_st, size: 1) if entry?)

    # 12
    def cod_ean = (normalize(value: cEANTrib, size: 16) unless final?)

    # Entries values
    # 13
    def qtd_entrada = (normalize(value: def_qtd_entrada, size: 12, decimals: 6) if entry?)

    # 14
    def valor_unit_ent = (normalize(value: def_valor_unit_ent, size: 12, decimals: 2) if entry?)

    # 15
    def valor_tot_ent = (normalize(value: def_valor_tot_ent, size: 12, decimals: 2) if entry?)

    # 16
    def aliq_op_prop = (normalize(value: def_aliq_op_prop, size: 3, decimals: 2) if entry?)

    # 17
    def bc_op_prop = (normalize(value: def_bc_op_prop, size: 12, decimals: 2) if entry?)

    # 18
    def icms_op_prop  = (normalize(value: def_icms_op_prop, size: 12, decimals: 2) if entry?)

    # 19
    def icms_unit_op_prop = (normalize(value: def_icms_unit_op_prop, size: 12, decimals: 2) if entry?)

    # 20
    def icms_fecomp = (normalize(value: def_icms_fecomp, size: 12, decimals: 2) if entry?)

    # ICMS ST values
    # 21
    def bc_icms_st
      normalize(value: def_bc_icms_st, size: 12, decimals: 2) if entry? && invoice_icms_st?
    end

    # 22
    def bc_unit_icms_st
      normalize(value: def_bc_unit_icms_st, size: 12, decimals: 2) if entry? && invoice_icms_st?
    end

    # 23
    def aliq_icms_st
      normalize(value: def_aliq_icms_st, size: 3, decimals: 2) if entry? && invoice_icms_st?
    end

    # 24
    def icms_st
      normalize(value: def_icms_st, size: 12, decimals: 2) if entry? && invoice_icms_st?
    end

    # 25
    def valor_icms_sup
      normalize(value: def_valor_icms_sup, size: 12, decimals: 2) if entry? && invoice_icms_st?
    end

    # 26
    def valor_uni_icms_sup
      normalize(value: def_valor_uni_icms_sup, size: 12, decimals: 2) if entry? && invoice_icms_st?
    end

    # 27
    def origem_inf = (normalize(value: def_origem_inf, size: 1, required: true) if entry? && invoice_icms_st?)

    # 28
    def daems = ''

    # 29
    def gnre = ''

    # Sales values
    # 30
    def cod_enq_saida = (normalize(value: def_cod_enq_saida, size: 1, required: true) if sale?)

    # 31
    def qtd_saida = (normalize(value: def_qtd_saida, size: 12, decimals: 6) if sale?)

    # 32
    def valor_unit_saida = (normalize(value: def_valor_unit_saida, size: 12, decimals: 2) if sale?)

    # 33
    def valor_saida = (normalize(value: def_valor_saida, size: 12, decimals: 2) if sale?)

    # 34
    def aliq_icms_efetiva = (normalize(value: def_aliq_icms_efetiva, size: 3, decimals: 2, required: true) if sale?)

    # 35
    def icms_efetivo = (normalize(value: def_icms_efetivo, size: 12, decimals: 2, required: true) if sale?)

    # 36
    def icms_prop_unit_transp
      normalize(value: def_icms_prop_unit_transp, size: 12, decimals: 2, required: true) if sale?
    end

    # 37
    def icms_prop_transp
      normalize(value: def_icms_prop_transp, size: 12, decimals: 2, required: true) if sale?
    end

    # 38
    def bc_unit_icms_sup_transp
      normalize(value: def_bc_unit_icms_sup_transp, size: 12, decimals: 2, required: true) if sale?
    end

    # 39
    def bc_icms_sup_transp
      normalize(value: def_bc_icms_sup_transp, size: 12, decimals: 2, required: true) if sale?
    end

    # 40
    def valor_unit_icms_sup_transp
      normalize(value: def_valor_unit_icms_sup_transp, size: 12, decimals: 2, required: true) if sale?
    end

    # 41
    def valor_icms_sup_transp_cf
      normalize(value: def_valor_icms_sup_transp_cf, size: 12, decimals: 2, required: true) if sale?
    end

    # 42
    def valor_icms_st_transp_fgn
      normalize(value: def_valor_icms_st_transp_fgn, size: 12, decimals: 2, required: true) if sale?
    end

    # 43
    def valor_icms_st_transp_isen
      normalize(value: def_valor_icms_st_transp_isen, size: 12, decimals: 2, required: true) if sale?
    end

    # 44
    def valor_icms_sup_transp_uf
      normalize(value: def_valor_icms_sup_transp_uf, size: 12, decimals: 2, required: true) if sale?
    end

    # FInal values
    # 45
    def qtd_estoque = normalize(value: def_qtd_estoque, size: 16, decimals: 6, required: true)

    # 46
    def icms_prop_unit_estoque = normalize(value: def_icms_prop_unit_estoque, size: 12, decimals: 2, required: true)

    # 47
    def saldo_bc_unit_icms_sup = normalize(value: def_saldo_bc_unit_icms_sup, size: 12, decimals: 2, required: true)

    # 48
    def saldo_icms_sup = normalize(value: def_saldo_icms_sup, size: 12, decimals: 2, required: true)

    # 49
    def saldo_icms_unit_sup = normalize(value: def_saldo_icms_unit_sup, size: 12, decimals: 2, required: true)

    # 50
    def apur_ressarc = normalize(value: def_apur_ressarc, size: 12, decimals: 2)

    # 50
    def apur_compl = normalize(value: def_apur_compl, size: 12, decimals: 2)
    # rubocop:disable Metrics/AbcSize

    def array_line
      [
        reg, cod_part, cod_item, descr_item, data, chave_acesso, cupom_fiscal, tipo_oper, cfop, cst, cod_oper_st,
        cod_ean, qtd_entrada, valor_unit_ent, valor_tot_ent, aliq_op_prop, bc_op_prop, icms_op_prop,
        icms_unit_op_prop, icms_fecomp, bc_icms_st, bc_unit_icms_st, aliq_icms_st, icms_st, valor_icms_sup,
        valor_uni_icms_sup, origem_inf, daems, gnre, cod_enq_saida, qtd_saida, valor_unit_saida, valor_saida,
        aliq_icms_efetiva, icms_efetivo, icms_prop_unit_transp, icms_prop_transp, bc_unit_icms_sup_transp,
        bc_icms_sup_transp, valor_unit_icms_sup_transp, valor_icms_sup_transp_cf, valor_icms_st_transp_fgn,
        valor_icms_st_transp_isen, valor_icms_sup_transp_uf, qtd_estoque, icms_prop_unit_estoque,
        saldo_bc_unit_icms_sup, saldo_icms_sup, saldo_icms_unit_sup, apur_ressarc, apur_compl
      ]
    end

    def show
      render(array_line)
    end
  end
end
