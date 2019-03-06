class PlayerStat < ActiveRecord::Base
#define API call to return a players stats and sort them from ost recent game
  def self.search_stats_by_player_id(player_id)
    response_string = RestClient.get("https://www.balldontlie.io/api/v1/stats?seasons[]=2018&player_ids[]=#{player_id}&per_page=500")
    player_stats = JSON.parse(response_string)["data"]

    player_stats_sorted = player_stats.sort_by {|game|
      -game["id"]}

    player_stats_sorted
  end

  ##Combines last game and season stats and prints as a table
  def self.combined_stats(player_stats)
    player_name = "#{player_stats[0]["player"]["first_name"]} #{player_stats[0]["player"]["last_name"]}"
    p "last game stats for #{player_name}:"
    game_data = {}
    game_data[:pts] = [player_stats[0]["pts"]]
    game_data[:ast] = [player_stats[0]["ast"]]
    game_data[:reb] = [player_stats[0]["reb"]]
    game_data[:stl] = [player_stats[0]["stl"]]
    game_data[:blk] = [player_stats[0]["blk"]]

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
    game_data[:pts] << (pts/num_of_games.to_f).round(1)
    game_data[:ast] << (ast/num_of_games.to_f).round(1)
    game_data[:reb] << (reb/num_of_games.to_f).round(1)
    game_data[:stl] << (stl/num_of_games.to_f).round(1)
    game_data[:blk] << (blk/num_of_games.to_f).round(1)

    data_table = Terminal::Table.new :headings =>['Stat','Last Game','Season'] do |t|
      t.add_row ["Points", game_data[:pts][0],game_data[:pts][1]]
      t.add_row ["Assists", game_data[:ast][0],game_data[:ast][1]]
      t.add_row ["Rebounds", game_data[:reb][0],game_data[:reb][1]]
      t.add_row ["Steals", game_data[:stl][0],game_data[:stl][1]]
      t.add_row ["Blocks", game_data[:blk][0],game_data[:blk][1]]
      t.style = {:all_separators => true}
      end
      puts data_table
  end
end
