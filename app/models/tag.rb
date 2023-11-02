class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
end
