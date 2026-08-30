# frozen_string_literal: true

DiscourseSticker::Engine.routes.draw { get "/site", to: "site#show", defaults: { format: :json } }
