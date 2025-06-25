class BadgesController < ApplicationController
  def index
    current_user.badges_check

    @score = Game.where(user_id: current_user.id).maximum(:total_score) || 0
    @count = Game.where(user_id: current_user.id).count
    @badges = current_user.badges.order(:id)
    @no_achieved_badges = Badge.where.not(id: @badges)
    @first_hit_count = current_user.first_hit_count
  end

  def select
    badge = Badge.find(params[:id])

    if current_user.badges.include?(badge)
      current_user.update(selected_badge_id: badge.id)
      flash[:success] = "「#{badge.name}」をお気に入り称号に設定しました！"
    else
      flash[:danger] = "不正な操作です。"
    end

    redirect_to badges_path
  end
end
