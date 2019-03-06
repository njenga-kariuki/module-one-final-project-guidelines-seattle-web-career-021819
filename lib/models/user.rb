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
    p " Thanks #{user_input_first_name} #{user_input_last_name}!"

    if User.find_by(first_name: user_input_first_name, last_name: user_input_last_name) != nil
      p 'Welcome back!'
      user_tracked_players
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
      User.new(first_name: first_name, last_name: last_name).save
      p "Welcome to the team, #{user_input_first_name}!"
      user_tracked_players
    when 2
      user_tracked_players
    end
  end

  #dashboard to show favorite players for a new user;
  def user_tracked_players

    p "Dashboard not yet created!"
    #User_Player.where(user_id: self.id).pluck(:player_id)
    ##need a method to pass players id and return stats
  end


end
