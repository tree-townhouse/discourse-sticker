# frozen_string_literal: true

module ::DiscourseSticker
  class Sticker < ActiveRecord::Base
    belongs_to :sticker_pack_revision,
               class_name: "DiscourseSticker::StickerPackRevision",
               inverse_of: :stickers
    belongs_to :upload

    has_many :upload_references, as: :target, dependent: :destroy

    validates :name,
              presence: true,
              length: {
                maximum: 80,
              },
              uniqueness: {
                scope: :sticker_pack_revision_id,
              }
    validates :position,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 0,
              },
              uniqueness: {
                scope: :sticker_pack_revision_id,
              }
    validate :revision_is_editable, on: :create

    before_update :prevent_changes_to_published_revision
    before_destroy :prevent_changes_to_published_revision

    after_save do
      if saved_change_to_upload_id?
        UploadReference.ensure_exist!(upload_ids: [upload_id], target: self)
      end
    end

    private

    def revision_is_editable
      return if !sticker_pack_revision&.published?

      errors.add(:base, "Published sticker pack revisions are immutable")
    end

    def prevent_changes_to_published_revision
      return if !sticker_pack_revision.published?

      errors.add(:base, "Published sticker pack revisions are immutable")
      throw :abort
    end
  end
end

# == Schema Information
#
# Table name: discourse_sticker_stickers
#
#  id                       :bigint           not null, primary key
#  name                     :string(80)       not null
#  position                 :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  sticker_pack_revision_id :bigint           not null
#  upload_id                :bigint           not null
#
# Indexes
#
#  idx_stickers_revision_name                     (sticker_pack_revision_id,name) UNIQUE
#  idx_stickers_revision_position                 (sticker_pack_revision_id,position) UNIQUE
#  index_discourse_sticker_stickers_on_upload_id  (upload_id)
#
# Foreign Keys
#
#  fk_rails_...  (sticker_pack_revision_id => discourse_sticker_sticker_pack_revisions.id)
#
