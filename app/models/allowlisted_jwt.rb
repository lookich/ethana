class AllowlistedJwt < ApplicationRecord
  scope :active, -> { where.not(exp: ..Time.now) }
end
