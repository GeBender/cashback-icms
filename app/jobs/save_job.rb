# frozen_string_literal: true

# == SaveRequestJob
#
# Save txt request file
#
class SaveJob < ApplicationJob
  queue_as :default
  include Register

  def perform(params)
    @request = Request.new(params)
    @output_file = File.new("requests/#{@request.filename}", 'w')
    @ressarc = @compl = 0
    populate_file

    @output_file.close
  end

  def populate_file
    add_start
    add_participants
    add_movements
    add_final_calc
    add_items
    add_item_conv
    add_final
  end

  def add_start
    add @request.company.show(@request.start_date, @request.end_date)
  end

  def add_participants
    @request.participants(@request.start_date, @request.end_date).each do |participant|
      add participant.show
    end
  end

  def add_movements
    @request.items.each do |item|
      item.stock(@request.start_date, @request.end_date).each do |stock|
        add stock.show
      end
      add item.show_resume
      @ressarc += item.ressarc
      @compl += item.compl
    end
  end

  def add_final_calc
    # add @request.show_final
    apur = @ressarc - @compl
    add render(
      [
        '3000',
        normalize(value: @ressarc, size: 12, decimals: 2),
        normalize(value: @compl, size: 12, decimals: 2),
        normalize(value: apur, size: 12, decimals: 2, required: true)
      ]
    )
  end

  def add_items
    @request.items.each do |item|
      add item.show
    end
  end

  def add_item_conv
    # TODO
    # @request.conv_items.each do |conv_item|
    #   add conv_item.show
    # end
  end

  def add_final
    lines = File.foreach(@output_file).count + 1
    add "9999|#{lines}"
  end

  def add(line)
    @output_file.puts("#{line}\n")
  end
end
