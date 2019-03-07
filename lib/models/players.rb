class Player < ActiveRecord::Base
  has_many :user_players
  has_many :users, through: :user_players

  #call BDL player api and return THEIR player id
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

  ##Call BDL and return the requested players team id
  def self.search_player_api_return_team_id(player_name)
    #call api
  response_string = RestClient.get("https://www.balldontlie.io/api/v1/players?&search=#{player_name[:last_name]}&per_page=500")
  response_hash = JSON.parse(response_string)

  player_hash = response_hash["data"].select do |player|
    player["first_name"].downcase == player_name[:first_name].downcase &&
    player["last_name"].downcase == player_name[:last_name].downcase
  end

  team_id = player_hash[0]["team"]["id"] unless player_hash.count == 0
  team_id
  end

  #gets all players for a team
  def self.get_all_team_player_ids(team_id)
    response_string = RestClient.get("https://www.balldontlie.io/api/v1/players?&per_page=3100")
    player_array = JSON.parse(response_string)["data"]

    team_player_ids = []
    player_array.each do |player|
      if player["team"]["id"] == team_id
        team_player_ids << player["id"]
      end
    end
    team_player_ids
  end

end
