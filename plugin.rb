# frozen_string_literal: true

# name: discourse-sticker
# about: Adds user-created sticker packs and stickers to Discourse.
# version: 0.1.0
# authors: tree-townhouse
# required_version: 3.5.0.beta1

enabled_site_setting :discourse_sticker_enabled

module ::DiscourseSticker
  PLUGIN_NAME = "discourse-sticker"
end

require_relative "lib/discourse_sticker/engine"

Discourse::Application.routes.append { mount ::DiscourseSticker::Engine, at: "/sticker" }
