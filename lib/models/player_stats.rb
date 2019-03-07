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
    p "Latest stats for #{player_name}:"
    game_data = {}
    game_data[:pts] = [player_stats[0]["pts"]]
    game_data[:ast] = [player_stats[0]["ast"]]
    game_data[:reb] = [player_stats[0]["reb"]]
    game_data[:stl] = [player_stats[0]["stl"]]
    game_data[:blk] = [player_stats[0]["blk"]]


    #last five games
    pts_t5 = 0
    ast_t5 = 0
    reb_t5 = 0
    stl_t5 = 0
    blk_t5 = 0
    i = 0
    player_stats[0..4].each do |game|
      pts_t5 += game["pts"] unless game["pts"] == nil
      ast_t5 += game["ast"] unless game["ast"] == nil
      reb_t5 += game["reb"] unless game["reb"] == nil
      stl_t5 += game["stl"] unless game["stl"] == nil
      blk_t5 += game["blk"] unless game["blk"] == nil
      i +=1
    end

    game_data[:pts] << (pts_t5/5.to_f).round(1)
    game_data[:ast] << (ast_t5/5.to_f).round(1)
    game_data[:reb] << (reb_t5/5.to_f).round(1)
    game_data[:stl] << (stl_t5/5.to_f).round(1)
    game_data[:blk] << (blk_t5/5.to_f).round(1)

    #Seasons stats
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

    data_table = Terminal::Table.new :headings =>['Stat','Last Game','Last 5 Games Avg.','Season Avg.'] do |t|
      t.add_row ["Points", game_data[:pts][0],game_data[:pts][1],game_data[:pts][2]]
      t.add_row ["Assists", game_data[:ast][0],game_data[:ast][1],game_data[:ast][2]]
      t.add_row ["Rebounds", game_data[:reb][0],game_data[:reb][1],game_data[:reb][2]]
      t.add_row ["Steals", game_data[:stl][0],game_data[:stl][1],game_data[:stl][2]]
      t.add_row ["Blocks", game_data[:blk][0],game_data[:blk][1],game_data[:blk][2]]
      t.style = {:all_separators => true}
      end
      puts data_table
  end


  ##Retreives player's team win/loss record and name
  def self.player_team_record(team_id)
    response_string = RestClient.get("https://www.balldontlie.io/api/v1/games?seasons[]=2018&team_ids[]=#{team_id}&per_page=100")
    player_team_stats = JSON.parse(response_string)["data"]

    player_team_stats_sorted = player_team_stats.sort_by {|game|
      -game["id"]}

      team_wins = 0
      team_losses = 0
      team_name = ""
      last_game_data = player_team_stats_sorted.find {|game|
        game["home_team_score"] > 1}
      last_game_status = nil
      last_game_opponent = nil
      last_game_score = nil
      last_game_date = last_game_data["date"].to_date.strftime("%a, %b-%d")

      #loop to get team name
      if last_game_data["home_team"]["id"] == team_id
        team_name = last_game_data["home_team"]["full_name"]
      else
        team_name = last_game_data["visitor_team"]["full_name"]
      end

      #loop to get last game win/loss
      if last_game_data["home_team"]["id"] == team_id
          last_game_opponent = last_game_data["visitor_team"]["full_name"]
          last_game_score = "#{last_game_data["home_team_score"]} -#{last_game_data["visitor_team_score"]}"
          if last_game_data["home_team_score"] >
            last_game_status = "Win"
          else
            last_game_status = "Loss"
          end
      else
        last_game_opponent = last_game_data["home_team"]["full_name"]
        last_game_score = "#{last_game_data["visitor_team_score"]} -#{last_game_data["home_team_score"]}"
          if last_game_data["visitor_team_score"] > last_game_data["home_team_score"]
            last_game_status = "Win"
          else
            last_game_status = "Loss"
          end
      end

      #loop to get season  win/loss record
      player_team_stats_sorted.each do |game|
        if game["home_team"]["id"] == team_id
          if game["home_team_score"] > game["visitor_team_score"]
            team_wins +=1
          elsif game["home_team_score"] < game["visitor_team_score"]
            team_losses +=1
          end
        elsif game["visitor_team"]["id"] == team_id
          if game["visitor_team_score"] > game["home_team_score"]
            team_wins +=1
          elsif game["visitor_team_score"] < game["home_team_score"]
            team_losses +=1
          end
        end
      end
      team_record = "#{team_wins} - #{team_losses}"
      p "#{team_name}: #{team_record}"
      p "Last game: #{last_game_status} (#{last_game_score}) vs. #{last_game_opponent} on #{last_game_date}"
  end

  ##test news api ## delete before push
  # def self.player_news
  #   # Init
  #   # newsapi = News.new("3a6e774b673a4d78a91f2fae405fb71b")
  #
  #   # player_headlines = newsapi.get_everything(q: 'lebron',
  #   #                                       sources: 'espn')
  #
  #   # player_headlines_clean = JSON.parse(player_headlines)
  #
  #   # url = 'https://newsapi.org/v2/everything?sources=espn&q=Lebron&sort_by=published_at.start=NOW-3DAYS&apiKey=3a6e774b673a4d78a91f2fae405fb71b'
  #     url = 'https://newsapi.org/v2/everything?sources=espn,fox-sports&q=lebron&apiKey=3a6e774b673a4d78a91f2fae405fb71b'
  #   req = open(url)
  #   response_body = req.read
  #   article_hash = {}
  #   article_hash[:articles] = response_body
  #
  #
  #   # response_body_cleaner.sort_by do |article|
  #   #   article["publishedAt"]
  #   # end
  #   p article_hash
  #
  #   #puts response_json_cleaner
  #   puts "hi"
end
