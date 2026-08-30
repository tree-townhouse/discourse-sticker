# frozen_string_literal: true

RSpec.describe DiscourseSticker::StickerPack do
  fab!(:owner, :user)

  it "normalizes and validates slugs" do
    pack = described_class.create!(owner: owner, slug: " My-Pack ")

    expect(pack.slug).to eq("my-pack")
    expect(described_class.new(owner: owner, slug: "bad slug")).not_to be_valid
  end

  it "requires unique slugs" do
    described_class.create!(owner: owner, slug: "sample-pack")
    duplicate = described_class.new(owner: owner, slug: "sample-pack")

    expect(duplicate).not_to be_valid
  end

  it "only accepts a published revision from the same pack as current" do
    other_pack = described_class.create!(owner: owner, slug: "other-pack")
    pack = described_class.create!(owner: owner, slug: "sample-pack")
    draft =
      DiscourseSticker::StickerPackRevision.create!(
        sticker_pack: pack,
        created_by: owner,
        version: 1,
        status: :draft,
        title: "Draft",
      )

    pack.current_revision = draft
    expect(pack).not_to be_valid

    published =
      DiscourseSticker::StickerPackRevision.create!(
        sticker_pack: other_pack,
        created_by: owner,
        version: 1,
        status: :published,
        title: "Published",
        published_at: Time.zone.now,
      )

    pack.current_revision = published
    expect(pack).not_to be_valid
  end
end
