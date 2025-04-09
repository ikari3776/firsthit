class Game < ApplicationRecord
  belongs_to :user, optional: true
  has_many :questions, dependent: :destroy

  def calculate_total_score
    self.update(total_score: questions.sum(:score), finished_at: Time.current)
  end
end
