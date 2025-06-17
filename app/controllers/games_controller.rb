class GamesController < ApplicationController
  def index
    session[:game_round] ||= 1
    session[:total_score] ||= 0

    session[:game_images] ||= Image.where.not(embedding: nil).order("RANDOM()").limit(5).pluck(:id)

    @current_score = session[:total_score]
    @random_image = Image.find_by(id: session[:game_images][session[:game_round] - 1])

    if @random_image.nil?
      reset_game_session
      flash[:danger] = "エラーが発生しました"
      redirect_to root_path and return
    end
  end

  def search
    if params[:query].blank?
      flash[:danger] = "検索ワードを入力してください"
      redirect_to games_path and return
    end

    @random_image = Image.find_by(id: params[:image_id])
    if @random_image.nil?
      reset_game_session
      flash[:danger] = "エラーが発生しました"
      redirect_to root_path and return
    end

    @query_text = params[:query]
    @query_embedding = EmbeddingGenerator.generate_embedding(@query_text)

    @all_ranked_images = Image.rank_all_images(@query_embedding)
    @similar_images = @all_ranked_images.first(10).map { |image| { image: image } }

    ranked_ids = @all_ranked_images.pluck(:id)
    @position = ranked_ids.index(@random_image.id)&.+(1)
    @score = calculate_score(@position)

    session[:total_score] += @score
    @current_round = session[:game_round]
    session[:game_round] += 1 if session[:game_round] <= 5

    render :search
  end

  def result
    @total_score = session[:total_score]

    if logged_in?
      Game.create!(
        user_id: current_user.id,
        total_score: @total_score,
        finished_at: Time.current
      )
    end

    session.delete(:game_round)
    session.delete(:total_score)
    session.delete(:game_images)
  end

  def reset_game_session
    reset_session
  end

  private

  def calculate_score(position)
    return 0 if position.nil?
    return 500 if position == 1

    base_score = 200 - position
    bonus = 300 / position

    base_score + bonus
  end
end
