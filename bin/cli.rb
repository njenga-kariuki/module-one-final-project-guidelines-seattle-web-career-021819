require_relative '../config/environment.rb'
##Run file responsible for executing the actual program##

#welcome message

p "Welcome to NBA Player Stat Tracker!"
sleep 1
p "We make it easy to track your favorite players stats through the NBA season."
User.user_authentication
# sleep 1
# player_query = User.full_user_input_and_search
#
# player_id = Player.search_player_api_return_id(player_query)
#
# sorted_player_data = PlayerStat.search_stats_by_player_id(player_id)
#
# PlayerStat.show_latest_game_stats(sorted_player_data)
#
# PlayerStat.season_game_stats(sorted_player_data)

#PlayerStat.player_news
