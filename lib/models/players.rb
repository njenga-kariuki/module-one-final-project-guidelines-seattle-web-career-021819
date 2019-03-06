class Player < ActiveRecord::Base
  has_many :user_players
  has_many :users, through: :user_players

  def self.search_player_api_return_id(player_name)
    #call api
  response_string = RestClient.get("https://www.balldontlie.io/api/v1/players?&search=#{player_name[:last_name]}&per_page=500")
  response_hash = JSON.parse(response_string)

  player_hash = response_hash["data"].select do |player|
    player["first_name"].downcase == player_name[:first_name].downcase &&
    player["last_name"].downcase == player_name[:last_name].downcase
  end

  player_id = player_hash[0]["id"] unless player_hash.count == 0
  player_id
  end
end
