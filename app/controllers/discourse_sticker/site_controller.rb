# frozen_string_literal: true

module DiscourseSticker
  class SiteController < ::ApplicationController
    requires_plugin DiscourseSticker::PLUGIN_NAME

    def show
      render json: {
               enabled: true,
               plugin_name: DiscourseSticker::PLUGIN_NAME,
             }
    end
  end
end
