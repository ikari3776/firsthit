class AddFirstHitCountToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :first_hit_count, :integer, default: 0, null: false
  end
end
