# frozen_string_literal: true

# Renderers
# Renderer main module
#
module Renderers
  # RequestRenderer
  # Help to render the request line
  #
  module RequestRenderer
    extend ActiveSupport::Concern
    include Register
  end
end
