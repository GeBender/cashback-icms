# frozen_string_literal: true

# Renderers
# Renderer main module
#
module Renderers
  # ItemRenderer
  # Help to render the items lines
  #
  module ItemRenderer
    extend ActiveSupport::Concern
    include Register

    def reg = '4000'
    def cod_item = normalize(value: cProd, string: true, size: 60, required: true)
    def desc_item = normalize(value: xProd, string: true, size: 60, required: true)
    def cod_ean = normalize(value: cEAN, size: 16, required: false)
    def cod_ant_item = ''
    def uni_inv = normalize(value: uTrib, string: true, size: 6, required: true)
    def tipo_item = '01'
    def ncm = normalize(value: self.NCM, size: 8, force_size: '0', required: true)
    def cest = normalize(value: self.CEST, size: 7, force_size: '0', required: true)

    def resume_reg = '2100'
    def qtd_est = normalize(value: stock.last.def_qtd_estoque, size: 16, decimals: 6, required: true)
    def icms_prop_est = normalize(value: stock.last.last_icms_prop, size: 12, decimals: 2, required: true)
    def bc_unit_icms_sup_est = normalize(value: stock.last.last_saldo_unit, size: 12, decimals: 2, required: true)
    def icms_sup_est = normalize(value: stock.last.last_saldo_unit, size: 12, decimals: 2, required: true)
    def apur_ressarc = normalize(value: stock.last.sum_ressarc, size: 12, decimals: 2, required: false)
    def apur_compl = normalize(value: stock.last.sum_compl, size: 12, decimals: 2, required: false)

    def show
      render([reg, cod_item, desc_item, cod_ean, cod_ant_item, uni_inv, tipo_item, ncm, cest])
    end

    def show_resume
      return unless stock.any?

      render(
        [
          resume_reg, cod_item, cod_ean, qtd_est, icms_prop_est, bc_unit_icms_sup_est,
          icms_sup_est, apur_ressarc, apur_compl
        ]
      )
    end
  end
end
