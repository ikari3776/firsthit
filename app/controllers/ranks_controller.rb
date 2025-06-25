class RanksController < ApplicationController
  def index
    high_score_game_ids = Game.select("DISTINCT ON (user_id) id")
                              .where.not(total_score: nil)
                              .order("user_id, total_score DESC, finished_at DESC")

    @all_ranks = Game.where(id: high_score_game_ids)
                     .includes(:user)
                     .order(total_score: :desc, finished_at: :desc, user_id: :asc)

    @top_ten_games = @all_ranks.limit(10)

    if logged_in?
      @current_user_high_score = Game.where(user_id: current_user.id).maximum(:total_score)
      @current_user_rank = @all_ranks.index { |rank| rank.user_id == current_user.id } + 1 rescue nil
    end
  end
end
