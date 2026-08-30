# frozen_string_literal: true

RSpec.describe "DiscourseSticker site endpoint" do
  describe "GET /sticker/site.json" do
    context "when the plugin is enabled" do
      before { SiteSetting.discourse_sticker_enabled = true }

      it "returns the plugin bootstrap payload" do
        get "/sticker/site.json"

        expect(response.status).to eq(200)
        expect(response.parsed_body).to eq(
          "enabled" => true,
          "plugin_name" => DiscourseSticker::PLUGIN_NAME,
        )
      end
    end

    context "when the plugin is disabled" do
      before { SiteSetting.discourse_sticker_enabled = false }

      it "does not expose the endpoint" do
        get "/sticker/site.json"

        expect(response.status).to eq(404)
      end
    end
  end
end
