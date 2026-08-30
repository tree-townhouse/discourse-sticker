# frozen_string_literal: true

module ::DiscourseSticker
  class StickerPack < ActiveRecord::Base
    belongs_to :owner, class_name: "User"
    belongs_to :current_revision,
               class_name: "DiscourseSticker::StickerPackRevision",
               optional: true

    has_many :revisions,
             class_name: "DiscourseSticker::StickerPackRevision",
             dependent: :restrict_with_error

    validates :slug,
              presence: true,
              uniqueness: true,
              length: {
                maximum: 80,
              },
              format: {
                with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/,
              }
    validate :current_revision_belongs_to_pack
    validate :current_revision_is_published

    before_validation :normalize_slug

    private

    def normalize_slug
      self.slug = slug.to_s.strip.downcase.presence
    end

    def current_revision_belongs_to_pack
      return if !current_revision || current_revision.sticker_pack_id == id

      errors.add(:current_revision, "must belong to this sticker pack")
    end

    def current_revision_is_published
      return if !current_revision || current_revision.published?

      errors.add(:current_revision, "must be published")
    end
  end
end

# == Schema Information
#
# Table name: discourse_sticker_sticker_packs
#
#  id                  :bigint           not null, primary key
#  slug                :string(80)       not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  current_revision_id :bigint
#  owner_id            :bigint           not null
#
# Indexes
#
#  index_discourse_sticker_sticker_packs_on_current_revision_id  (current_revision_id)
#  index_discourse_sticker_sticker_packs_on_owner_id             (owner_id)
#  index_discourse_sticker_sticker_packs_on_slug                 (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (current_revision_id => discourse_sticker_sticker_pack_revisions.id)
#
