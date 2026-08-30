# frozen_string_literal: true

module DiscourseSticker
  class SiteController < ::ApplicationController
    requires_plugin DiscourseSticker::PLUGIN_NAME

    def show
      render json: {
               enabled: true,
               plugin_name: DiscourseSticker::PLUGIN_NAME,
               can_use_stickers: guardian.can_use_stickers?,
               can_upload_stickers: guardian.can_upload_stickers?,
               upload_requires_approval: guardian.sticker_upload_requires_approval?,
             }
    end
  end
end
