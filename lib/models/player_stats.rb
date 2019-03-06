class PlayerStat
#define API call to treutn a players stats
  def self.search_stats_by_player_id(player_id)
    response_string = RestClient.get("https://www.balldontlie.io/api/v1/stats?seasons[]=2018&player_ids[]=#{player_id}&per_page=500")
    response_hash = JSON.parse(response_string)

    latest_game_hash = {}
    latest_game_hash[:ast] = response_hash["data"][0]["ast"]
    latest_game_hash[:blk] = response_hash["data"][0]["blk"]
    latest_game_hash[:pts] = response_hash["data"][0]["pts"]
    latest_game_hash[:reb] = response_hash["data"][0]["reb"]
    latest_game_hash[:stl] = response_hash["data"][0]["stl"]
    puts latest_game_hash
  end

#   def latest_game_stats(dataset)
#     latest_game_hash = {}
#     latest_game_hash[:ast] = dataset["data"][0]["ast"]
#     latest_game_hash[:blk] = dataset["data"][0]["blk"]
#     latest_game_hash[:pts] = dataset["data"][0]["pts"]
#     latest_game_hash[:reb] = dataset["data"][0]["reb"]
#     latest_game_hash[:stl] = dataset["data"][0]["stl"]
#   end
#
#   def show_latest_game_stats
#     dataset = self.
#   end
#
end
