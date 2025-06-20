class User < ApplicationRecord
  authenticates_with_sorcery!
  authenticates_with_sorcery! do |config|
    config.reset_password_mailer = UserMailer
  end

  validates :name, presence: true,
                   uniqueness: true,
                   length: { in: 3..20 },
                   format: { with: /\A[a-zA-Z0-9]+\z/, message: "は半角英数字のみ使用できます" }
  validates :password, confirmation: true,
                       length: { minimum: 3 }, on: :create
  validates :password_confirmation, length: { minimum: 3 }, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :games, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges

  def badges_check
    score = Game.where(user_id: id).maximum(:total_score) || 0
    game_count = Game.where(user_id: id).count || 0

    badge_names = [ "初めてログインする" ]
    badge_names << "1000点以上獲得する" if score >= 1000
    badge_names << "1500点以上獲得する" if score >= 1500
    badge_names << "2000点以上獲得する" if score >= 2000
    badge_names << "2500点獲得する"     if score >= 2500

    badge_names << "5回以上プレイする"   if game_count >= 5
    badge_names << "10回以上プレイする"  if game_count >= 10
    badge_names << "30回以上プレイする"  if game_count >= 30
    badge_names << "50回以上プレイする"  if game_count >= 50
    badge_names << "100回以上プレイする" if game_count >= 100
    badge_names << "500回以上プレイする" if game_count >= 500
    badge_names << "1000回以上プレイする" if game_count >= 1000

    badge_names << "初めてFIRST HITする"   if first_hit_count >= 1
    badge_names << "5回FIRST HITする"   if first_hit_count >= 5
    badge_names << "10回FIRST HITする"   if first_hit_count >= 10
    badge_names << "50回FIRST HITする"   if first_hit_count >= 50
    badge_names << "100回FIRST HITする"  if first_hit_count >= 100

    new_badges = Badge.where(name: badge_names)

    new_badges.each do |badge|
      user_badges.find_or_create_by!(badge_id: badge.id)
    end

    badges
  end

  def assign_new_badges_from_game(game)
    newly_earned = []

    score = game.total_score
    game_count = Game.where(user_id: id).count

    badge_names = []
    badge_names << "1000点以上獲得する" if score >= 1000
    badge_names << "1500点以上獲得する" if score >= 1500
    badge_names << "2000点以上獲得する" if score >= 2000
    badge_names << "2500点獲得する"     if score >= 2500

    badge_names << "5回以上プレイする"   if game_count >= 5
    badge_names << "10回以上プレイする"  if game_count >= 10
    badge_names << "30回以上プレイする"  if game_count >= 30
    badge_names << "50回以上プレイする"  if game_count >= 50
    badge_names << "100回以上プレイする" if game_count >= 100
    badge_names << "500回以上プレイする" if game_count >= 500
    badge_names << "1000回以上プレイする" if game_count >= 1000

    badge_names << "初めてFIRST HITする"   if first_hit_count >= 1
    badge_names << "5回FIRST HITする"   if first_hit_count >= 5
    badge_names << "10回FIRST HITする"   if first_hit_count >= 10
    badge_names << "50回FIRST HITする"   if first_hit_count >= 50
    badge_names << "100回FIRST HITする"  if first_hit_count >= 100

    new_badges = Badge.where(name: badge_names)

    new_badges.each do |badge|
      user_badge = user_badges.find_or_initialize_by(badge_id: badge.id)
      if user_badge.new_record?
        user_badge.save!
        newly_earned << badge
      end
    end

    newly_earned
  end
end
