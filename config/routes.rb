# frozen_string_literal: true

DiscourseSticker::Engine.routes.draw do
  get "/site" => "site#show", defaults: { format: :json }
end
