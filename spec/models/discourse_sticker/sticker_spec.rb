# frozen_string_literal: true

RSpec.describe DiscourseSticker::Sticker do
  fab!(:owner) { Fabricate(:user) }
  fab!(:upload)
  fab!(:other_upload) { Fabricate(:upload) }

  let(:pack) { DiscourseSticker::StickerPack.create!(owner: owner, slug: "sample-pack") }
  let(:draft_revision) do
    DiscourseSticker::StickerPackRevision.create!(
      sticker_pack: pack,
      created_by: owner,
      version: 1,
      status: :draft,
      title: "Draft",
    )
  end

  it "keeps names and positions unique within a revision" do
    described_class.create!(
      sticker_pack_revision: draft_revision,
      upload: upload,
      name: "hello",
      position: 0,
    )

    duplicate_name =
      described_class.new(
        sticker_pack_revision: draft_revision,
        upload: other_upload,
        name: "hello",
        position: 1,
      )
    duplicate_position =
      described_class.new(
        sticker_pack_revision: draft_revision,
        upload: other_upload,
        name: "goodbye",
        position: 0,
      )

    expect(duplicate_name).not_to be_valid
    expect(duplicate_position).not_to be_valid
  end

  it "registers its upload as referenced" do
    sticker =
      described_class.create!(
        sticker_pack_revision: draft_revision,
        upload: upload,
        name: "hello",
        position: 0,
      )

    expect(UploadReference.exists?(upload_id: upload.id, target: sticker)).to eq(true)
  end

  it "does not allow stickers to be added to a published revision" do
    revision =
      DiscourseSticker::StickerPackRevision.create!(
        sticker_pack: pack,
        created_by: owner,
        version: 2,
        status: :published,
        title: "Published",
        published_at: Time.zone.now,
      )
    sticker =
      described_class.new(
        sticker_pack_revision: revision,
        upload: upload,
        name: "hello",
        position: 0,
      )

    expect(sticker).not_to be_valid
  end

  it "does not allow existing stickers to change after their revision is published" do
    sticker =
      described_class.create!(
        sticker_pack_revision: draft_revision,
        upload: upload,
        name: "hello",
        position: 0,
      )
    draft_revision.update!(status: :published, published_at: Time.zone.now)

    expect(sticker.update(name: "changed")).to eq(false)
    expect(sticker.reload.name).to eq("hello")

    sticker.destroy
    expect(sticker).to be_persisted
  end
end
