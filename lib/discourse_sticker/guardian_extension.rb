# frozen_string_literal: true

module ::DiscourseSticker
  module GuardianExtension
    def can_use_stickers?
      sticker_group_permission?(SiteSetting.discourse_sticker_use_allowed_groups)
    end

    def can_upload_stickers?
      sticker_group_permission?(SiteSetting.discourse_sticker_upload_allowed_groups)
    end

    def sticker_upload_requires_approval?
      return false if !can_upload_stickers? || is_staff?

      user.trust_level <
        SiteSetting.discourse_sticker_upload_approval_required_below_trust_level ||
        user.in_any_groups?(
          DiscourseSticker.group_ids(
            SiteSetting.discourse_sticker_upload_approval_required_groups,
          ),
        )
    end

    private

    def sticker_group_permission?(setting)
      return false if !SiteSetting.discourse_sticker_enabled || !authenticated?
      return true if is_staff?

      user.in_any_groups?(DiscourseSticker.group_ids(setting))
    end
  end

  def self.group_ids(setting)
    setting.to_s.split("|").filter_map { |id| Integer(id, exception: false) }.uniq
  end
end
