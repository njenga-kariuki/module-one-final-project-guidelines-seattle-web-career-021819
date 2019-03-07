class User < ActiveRecord::Base
  has_many :user_players
  has_many :players, through: :user_players
  #each user has a first and last name

  #CLI player search: enable user to serach for a given player and retreive latest game status
  def self.player_search_input
    puts "Enter the first and last name of the player you want to track"
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
    puts "Please enter your first name:"
      user_input_first_name = gets.chomp.capitalize
    puts "and your last name:"
      user_input_last_name = gets.chomp.capitalize
    system "clear"
    current_user = User.find_by(first_name: user_input_first_name, last_name: user_input_last_name)
    if current_user != nil
      puts "Welcome back #{current_user.first_name}!"
      current_user.user_tracked_players
    else
      self.new_user_option_flow(user_input_first_name, user_input_last_name)
    end
  end

  #enables create new user or search players ad-hoc
  def self.new_user_option_flow(first_name, last_name)
    puts "It appears you do not have an account with us!"
      sleep 1
    puts "Please enter one of the following numbers:
      1 - Create account to automatically track my favorite players
      2 - Search player stats without an account"

    user_input = gets.chomp.to_i
    system "clear"
    case user_input
    when 1
      current_user = User.create(first_name: first_name, last_name: last_name)
      puts "Welcome to the team, #{first_name}!"
      current_user.add_favorite_player
    when 2
      player_query = self.full_user_input_and_search
      player_id = Player.search_player_api_return_id(player_query)
        if player_id == nil
          system "clear"
          puts "Sorry invalid player name!".red.blink
          self.loop_search
        else
          system "clear"
          sorted_player_data = PlayerStat.search_stats_by_player_id(player_id)
          PlayerStat.combined_stats(sorted_player_data)
          team_num =  Player.search_player_api_return_team_id(player_query)
          PlayerStat.player_team_record(team_num)
          self.loop_search
        end
    end
  end

  def self.loop_search
    puts "Enter one of the following numbers:
      1 - Search another player
      2 - Exit"
      user_input = gets.chomp.to_i
      system "clear"
    case user_input
    when 1
      player_query = self.full_user_input_and_search
      player_id = Player.search_player_api_return_id(player_query)
        if player_id == nil
          system "clear"
          puts "Sorry invalid player name!".red.blink
          self.loop_search
        else
          system "clear"
          sorted_player_data = PlayerStat.search_stats_by_player_id(player_id)
          PlayerStat.combined_stats(sorted_player_data)
          team_num =  Player.search_player_api_return_team_id(player_query)
          PlayerStat.player_team_record(team_num)
          self.loop_search
        end
    when 2
      puts "Goodbye!"
      exit
    end
  end


  #method that asks new or existing users to start tracking Players
  def add_favorite_player
    player_name = User.full_user_input_and_search
    player_id = Player.search_player_api_return_id(player_name)
      if player_id == nil
        puts "Sorry invalid player name!".red.blink
        self.add_favorite_player
      else
        track_player = Player.create(first_name: player_name[:first_name], last_name: player_name[:last_name])
        UserPlayer.create(user_id:self.id, player_id:track_player.id)
        puts "We've added #{track_player.first_name} #{track_player.last_name} to your queue!"
        puts "Enter one of the following numbers:
          1 - Add more players
          2 - View player stats
          3 - Exit"
        self.loop_favorite_player
      end
  end

  #after a user adds one player, a loop to let them add more
  def loop_favorite_player
    user_input = gets.chomp.to_i
    system "clear"
    case user_input
    when 1
      self.add_favorite_player
    when 2
      puts self.user_tracked_players
    when 3
      puts "Goodbye!"
      exit
    end
  end

  #dashboard to show favorite players for an existing user
  def user_tracked_players
    #query the userplayer table and loop through
    test = UserPlayer.where(user_id:self.id).pluck(:player_id)

    if test.count == 0
      puts "You are not tracking any players yet. Let's fix that!"
      self.add_favorite_player
    else
      test.each do |player_id|
        lookup_player = Player.find_by(id:player_id)
        puts lookup_player.class
        player_hash = {}
        player_hash[:first_name] = lookup_player.first_name
        player_hash[:last_name] = lookup_player.last_name
        player_id =  Player.search_player_api_return_id(player_hash)
        sorted_data = PlayerStat.search_stats_by_player_id(player_id)
        PlayerStat.combined_stats(sorted_data)
        team_num =  Player.search_player_api_return_team_id(player_hash)
        PlayerStat.player_team_record(team_num)
      end
      self.user_option_menu
    end
  end

  #enable a user to delete from tracked_list
  def deleted_a_favorite_tracked_player
    puts "To delete one of your tracked players, please enter the number next to the player's name:"

    self.players.each_with_index do |player,index|
      puts "#{player.first_name} #{player.last_name} - #{index+1}"
    end

    user_input = (gets.chomp.to_i) - 1
    delete_player = self.players[user_input]

    UserPlayer.find_by(user_id: self.id, player_id: delete_player.id).delete
    system "clear"
    puts "Deleted!"
    self.user_option_menu
  end

  #method that shows menu options after users view stats
  def user_option_menu
    puts "Enter one of the following numbers:
      1 - Add Tracked Player
      2 - Delete Tracked Player
      3 - Exit"
    user_input = gets.chomp.to_i
    system "clear"
    case user_input
    when 1
      self.add_favorite_player
    when 2
      self.deleted_a_favorite_tracked_player
    when 3
      puts "Thanks, Goodbye!"
    end
  end

end
