class User < ActiveRecord::Base
  has_many :user_players
  has_many :players, through: :user_players
  #each user has a first and last name

  #CLI player search: enable user to serach for a given player and retreive latest game status

  def self.player_search_input
    p "Enter the first and last name of your favorite player and hit enter to search."
    user_input = gets.chomp
    user_input.split(" ").to_a
  end

  #formats player_search_input into hash for API search
  def self.format_player_api_search(user_input)
    api_player_search = {}
    user_input.each do
      api_player_search[:first_name] = user_input[0]
      api_player_search[:last_name] = user_input[1]
    end
    api_player_search ## for testing
  end

  ##combines methods to take user input to search player and return correct format for API search
  def self.full_user_input_and_search
    input = self.player_search_input
    format_player_api_search(input)
  end

  ###collects user input for first and last name
  def self.user_authentication
    p "Please enter your first name:"
    user_input_first_name = gets.chomp.capitalize
    p "and your last name:"
    user_input_last_name = gets.chomp.capitalize

    current_user = User.find_by(first_name: user_input_first_name, last_name: user_input_last_name)
    if current_user != nil
      p "Welcome back #{current_user.first_name}!"
      current_user.user_tracked_players
    else
      self.new_user_option_flow(user_input_first_name, user_input_last_name)
    end
  end

  #enables create new user or search players ad-hoc
  def self.new_user_option_flow(first_name, last_name)
    p "Welcome! It appears you do not have an account with us!"
    sleep 1
    p "Please select from the following menu (input the number):
    1. Create account so I can automatically track favorite players
      2. Search player stats without an account"

    user_input = gets.chomp.to_i

    case user_input
    when 1
      current_user = User.create(first_name: first_name, last_name: last_name)
      p "Welcome to the team, #{first_name}!"
      current_user.add_favorite_player
    when 2
      player_query = self.full_user_input_and_search
      player_id = Player.search_player_api_return_id(player_query)
      sorted_player_data = PlayerStat.search_stats_by_player_id(player_id)
      PlayerStat.combined_stats(sorted_player_data)
      self.loop_search
    end
  end

  def self.loop_search
    p "Enter 1 to search another player or 2 to exit"
    user_input = gets.chomp.to_i
    case user_input
    when 1
      player_query = self.full_user_input_and_search
      player_id = Player.search_player_api_return_id(player_query)
      sorted_player_data = PlayerStat.search_stats_by_player_id(player_id)
      PlayerStat.combined_stats(sorted_player_data)
      self.loop_search
    when 2
      p "goodbye"
      exit
    end
  end


  #method that asks new or existing users to start tracking Players
  def add_favorite_player
    player_name = User.full_user_input_and_search
    track_player = Player.create(first_name: player_name[:first_name], last_name: player_name[:last_name])
    UserPlayer.create(user_id:self.id, player_id:track_player.id)
    p "We've added #{track_player.first_name} #{track_player.last_name} to your queue!"
    p "Enter 1 to add more players, 2 to view stats, 3 to exit"
    loop_favorite_player
  end

  #after a user adds one player, a loop to let them add more
  def loop_favorite_player
    user_input = gets.chomp.to_i
    case user_input
    when 1
      self.add_favorite_player
    when 2
      p self.user_tracked_players
    when 3
      p "goodbye"
      exit
    end
  end

  #dashboard to show favorite players for an existing user
  def user_tracked_players
    #query the userplayer table and loop through
    test = UserPlayer.where(user_id:self.id).pluck(:player_id)

    test.each do |player_id|
      lookup_player = Player.find_by(id:player_id)
      puts lookup_player.class
      player_hash = {}
      player_hash[:first_name] = lookup_player.first_name
      player_hash[:last_name] = lookup_player.last_name
      player_num =  Player.search_player_api_return_id(player_hash)
      sorted_data = PlayerStat.search_stats_by_player_id(player_num)
      PlayerStat.combined_stats(sorted_data)
    end
  end
end
