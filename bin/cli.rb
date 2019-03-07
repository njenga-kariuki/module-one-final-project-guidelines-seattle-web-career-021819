require_relative '../config/environment.rb'
##Run file responsible for executing the actual program##
system "clear"
#welcome message

Catpix::print_image "NBA2.png",
  :limit_x => 0.8,
  :limit_y => 0.8,
  :center_x => true,
  :center_y => true,
  :resolution => "high"

puts  " __        __   _                            _          _   _ ____    _      ____  _        _     _____               _             _ ".red.blink
puts  " \\ \\      / /__| | ___ ___  _ __ ___   ___  | |_ ___   | \\ | | __ )  / \\    / ___|| |_ __ _| |_  |_   _| __ __ _  ___| | _____ _ __| |".white.blink
puts  "  \\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\ | __/ _ \\  |  \\| |  _ \\ / _ \\   \\___ \\| __/ _` | __|   | || '__/ _` |/ __| |/ / _ \\ '__| |".blue.blink
puts  "   \\ V  V /  __/ | (_| (_) | | | | | |  __/ | || (_) | | |\\  | |_) / ___ \\   ___) | || (_| | |_    | || | | (_| | (__|   <  __/ |  |_|".white.blink
puts  "    \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___|  \\__\\___/  |_| \\_|____/_/   \\_\\ |____/ \\__\\__,_|\\__|   |_||_|  \\__,_|\\___|_|\\_\\___|_|  (_)".red.blink


puts

sleep 1
puts "We make it easy to track your favorite player's stats throughout the NBA season".bold
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
