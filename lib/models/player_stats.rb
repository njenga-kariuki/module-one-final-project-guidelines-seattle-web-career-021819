class PlayerStat < ActiveRecord::Base
#define API call to return a players stats and sort them from ost recent game
  def self.search_stats_by_player_id(player_id)
    response_string = RestClient.get("https://www.balldontlie.io/api/v1/stats?seasons[]=2018&player_ids[]=#{player_id}&per_page=500")
    player_stats = JSON.parse(response_string)["data"]

    player_stats_sorted = player_stats.sort_by {|game|
      -game["id"]}

    player_stats_sorted
  end

  #takes in sorted game stats of a player and prints latest game
  def self.show_latest_game_stats(player_stats)
    p "last game stats:"
    latest_game = {}
    latest_game[:pts] = player_stats[0]["pts"]
    latest_game[:ast] = player_stats[0]["ast"]
    latest_game[:reb] = player_stats[0]["reb"]
    latest_game[:stl] = player_stats[0]["stl"]
    latest_game[:blk] = player_stats[0]["blk"]

    p latest_game
  end

  #iterate through season stats, calc season averages, print them
  def self.season_game_stats(player_stats)
    p "season stats:"
    season_stats = {}
    num_of_games = player_stats.count
    pts = 0
    ast = 0
    reb = 0
    stl = 0
    blk = 0

    player_stats.each do |game|
      pts += game["pts"] unless game["pts"] == nil
      ast += game["ast"] unless game["ast"] == nil
      reb += game["reb"] unless game["reb"] == nil
      stl += game["stl"] unless game["stl"] == nil
      blk += game["blk"] unless game["blk"] == nil

    end
    season_stats[:pts] = (pts/num_of_games.to_f).round(1)
    season_stats[:ast] = (ast/num_of_games.to_f).round(1)
    season_stats[:reb] = (reb/num_of_games.to_f).round(1)
    season_stats[:stl] = (stl/num_of_games.to_f).round(1)
    season_stats[:blk] = (blk/num_of_games.to_f).round(1)

    p season_stats
  end
end
