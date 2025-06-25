class ChangeSelectedBadgeIdDefaultOnUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :selected_badge_id, from: nil, to: 1
  end
end
