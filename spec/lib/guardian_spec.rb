# frozen_string_literal: true

RSpec.describe Guardian do
  before { SiteSetting.discourse_sticker_enabled = true }

  describe "sticker permissions" do
    fab!(:user) { Fabricate(:user, refresh_auto_groups: true) }
    fab!(:other_user) { Fabricate(:user, refresh_auto_groups: true) }
    fab!(:group)

    it "denies anonymous users" do
      guardian = described_class.new

      expect(guardian.can_use_stickers?).to eq(false)
      expect(guardian.can_upload_stickers?).to eq(false)
      expect(guardian.sticker_upload_requires_approval?).to eq(false)
    end

    it "allows members of the configured use and upload groups" do
      group.add(user)
      SiteSetting.discourse_sticker_use_allowed_groups = group.id.to_s
      SiteSetting.discourse_sticker_upload_allowed_groups = group.id.to_s

      expect(described_class.new(user).can_use_stickers?).to eq(true)
      expect(described_class.new(user).can_upload_stickers?).to eq(true)
      expect(described_class.new(other_user).can_use_stickers?).to eq(false)
      expect(described_class.new(other_user).can_upload_stickers?).to eq(false)
    end

    it "always allows staff to use and upload stickers" do
      admin = Fabricate(:admin)
      SiteSetting.discourse_sticker_use_allowed_groups = ""
      SiteSetting.discourse_sticker_upload_allowed_groups = ""

      expect(described_class.new(admin).can_use_stickers?).to eq(true)
      expect(described_class.new(admin).can_upload_stickers?).to eq(true)
    end

    it "requires approval below the configured trust level" do
      user.update!(trust_level: TrustLevel[1])
      SiteSetting.discourse_sticker_upload_approval_required_below_trust_level = TrustLevel[2]

      expect(described_class.new(user).sticker_upload_requires_approval?).to eq(true)
    end

    it "requires approval for members of a configured group" do
      group.add(user)
      SiteSetting.discourse_sticker_upload_approval_required_groups = group.id.to_s

      expect(described_class.new(user).sticker_upload_requires_approval?).to eq(true)
    end

    it "does not require staff approval" do
      moderator = Fabricate(:moderator)
      SiteSetting.discourse_sticker_upload_approval_required_below_trust_level = TrustLevel[4]

      expect(described_class.new(moderator).sticker_upload_requires_approval?).to eq(false)
    end

    it "denies permissions when the plugin is disabled" do
      SiteSetting.discourse_sticker_enabled = false

      expect(described_class.new(user).can_use_stickers?).to eq(false)
      expect(described_class.new(user).can_upload_stickers?).to eq(false)
      expect(described_class.new(user).sticker_upload_requires_approval?).to eq(false)
    end
  end
end
