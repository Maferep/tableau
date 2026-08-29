class Image < ApplicationRecord
    validate :sane_image
    def sane_image
        if content.byte_size > 1000 * 1000 * 100
            errors.add(:byte_size, "must not exceed 100MB.")
        end
    end
    has_one_attached :content
end
