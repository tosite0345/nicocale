# frozen_string_literal: true

class TeamUser < ApplicationRecord
  has_one :team
  has_one :user
  validate :exist_team_id
  validate :exist_user_id

  private
    def exist_team_id
      errors.add(:team_id, "team_idが存在しません。") if Team.all.ids.exclude?(team_id)
    end
    def exist_user_id
      errors.add(:user_id, "user_idが存在しません。") if User.all.ids.exclude?(user_id)
    end
end