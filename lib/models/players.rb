#responsible for all class methods for player_search_input

#search API for player ID after receiving input -- first search with last name and then if not a match, search all players
class Player
  def self.search_player_api_return_id(player_name)
    #call api
  response_string = RestClient.get("https://www.balldontlie.io/api/v1/players?&search=#{player_name[:last_name]}&per_page=500")
  response_hash = JSON.parse(response_string)

    #iterate through response and check for match and return player
  player_hash = response_hash["data"].select do |player|
    player["first_name"].downcase == player_name[:first_name].downcase &&
    player["last_name"].downcase == player_name[:last_name].downcase
  end

    #isolate the players # ID
  player_id = player_hash[0]["id"]

    #error handling in return value
    if player_id == nil
      "Sorry, we could not find your player.Please ensure spelling is accurate."
    else
      player_id
    end
  end
end
