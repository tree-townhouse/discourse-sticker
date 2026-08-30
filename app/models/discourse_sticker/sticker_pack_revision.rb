# frozen_string_literal: true

module ::DiscourseSticker
  class StickerPackRevision < ActiveRecord::Base
    belongs_to :sticker_pack, class_name: "DiscourseSticker::StickerPack"
    belongs_to :created_by, class_name: "User"
    belongs_to :cover_upload, class_name: "Upload", optional: true

    has_many :stickers,
             class_name: "DiscourseSticker::Sticker",
             dependent: :destroy,
             inverse_of: :sticker_pack_revision
    has_many :upload_references, as: :target, dependent: :destroy

    enum :status, { draft: 0, pending: 1, published: 2, rejected: 3 }, scopes: false

    validates :title, presence: true, length: { maximum: 120 }
    validates :version,
              numericality: {
                only_integer: true,
                greater_than: 0,
              },
              uniqueness: {
                scope: :sticker_pack_id,
              }
    validates :published_at, presence: true, if: :published?

    before_update :prevent_published_revision_changes
    before_destroy :prevent_published_revision_destruction

    after_save do
      if saved_change_to_cover_upload_id? && cover_upload_id
        UploadReference.ensure_exist!(upload_ids: [cover_upload_id], target: self)
      end
    end

    private

    def prevent_published_revision_changes
      return if status_in_database != "published"

      errors.add(:base, "Published sticker pack revisions are immutable")
      throw :abort
    end

    def prevent_published_revision_destruction
      return if !published?

      errors.add(:base, "Published sticker pack revisions are immutable")
      throw :abort
    end
  end
end

# == Schema Information
#
# Table name: discourse_sticker_sticker_pack_revisions
#
#  id              :bigint           not null, primary key
#  description     :text
#  published_at    :datetime
#  status          :integer          default("draft"), not null
#  title           :string(120)      not null
#  version         :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cover_upload_id :bigint
#  created_by_id   :bigint           not null
#  sticker_pack_id :bigint           not null
#
# Indexes
#
#  idx_on_cover_upload_id_dbdd32550c         (cover_upload_id)
#  idx_on_created_by_id_75b8ed35dc           (created_by_id)
#  idx_on_sticker_pack_id_status_cc46e844db  (sticker_pack_id,status)
#  idx_sticker_pack_revisions_pack_version   (sticker_pack_id,version) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (sticker_pack_id => discourse_sticker_sticker_packs.id)
#
