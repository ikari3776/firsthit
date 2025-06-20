class BadgesController < ApplicationController
  def index
    current_user.badges_check

    @score = Game.where(user_id: current_user.id).maximum(:total_score) || 0
    @count = Game.where(user_id: current_user.id).count
    @badges = current_user.badges
    @no_achieved_badges = Badge.where.not(id: @badges)
    @first_hit_count = current_user.first_hit_count
  end
end
