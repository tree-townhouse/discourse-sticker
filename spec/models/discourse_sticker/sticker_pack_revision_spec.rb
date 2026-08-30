# frozen_string_literal: true

RSpec.describe DiscourseSticker::StickerPackRevision do
  fab!(:owner) { Fabricate(:user) }

  let(:pack) { DiscourseSticker::StickerPack.create!(owner: owner, slug: "sample-pack") }

  it "keeps versions unique inside a sticker pack" do
    described_class.create!(
      sticker_pack: pack,
      created_by: owner,
      version: 1,
      status: :draft,
      title: "Version 1",
    )

    duplicate =
      described_class.new(
        sticker_pack: pack,
        created_by: owner,
        version: 1,
        status: :draft,
        title: "Duplicate",
      )

    expect(duplicate).not_to be_valid
  end

  it "allows a draft to become published" do
    revision =
      described_class.create!(
        sticker_pack: pack,
        created_by: owner,
        version: 1,
        status: :draft,
        title: "Version 1",
      )

    revision.update!(status: :published, published_at: Time.zone.now)

    expect(revision).to be_published
  end

  it "prevents changes after publication" do
    revision = published_revision

    expect(revision.update(title: "Changed")).to eq(false)
    expect(revision.reload.title).to eq("Published")
  end

  it "prevents published revisions from being destroyed" do
    revision = published_revision

    revision.destroy

    expect(revision).to be_persisted
  end

  private

  def published_revision
    described_class.create!(
      sticker_pack: pack,
      created_by: owner,
      version: 1,
      status: :published,
      title: "Published",
      published_at: Time.zone.now,
    )
  end
end
