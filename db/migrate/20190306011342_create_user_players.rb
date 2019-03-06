class CreateUserPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_players do |t|
      t.integer :user_id
      t.integer :player_id
    end
  end
end
