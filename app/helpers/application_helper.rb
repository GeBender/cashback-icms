# frozen_string_literal: true

module ApplicationHelper
  # include Pagy::Frontend

  def url_nav(pairs)
    query = parse_query(request)
    pairs.each do |pair|
      query[pair.first.to_s] = pair.second.to_s #nless pair.second.to_s.blank?
    end

    "#{request.path}?#{build_query(query)}"
  end

  def parse_query(request)
    Rack::Utils.parse_query(URI.parse(request.fullpath).query)
  end

  def build_query(query)
    Rack::Utils.build_query(query)
  end

  def sort_link(field, default_order = 'asc')
    reverse = { 'asc' => 'desc', 'desc' => 'asc' }
    order = params[:orderBy] == field ? reverse[params[:order]] : default_order
    url_nav({ orderBy: field, order:, page: 1 })
  end

  def reversed(field)
    field == params[:orderBy] && params[:order] == 'desc'
  end

  def sort_icon(field)
    return unless params[:orderBy] == field

    params[:order] == 'asc' ? '-up' : '-down'
  end
end
