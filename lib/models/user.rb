class User

  #CLI player search: enable user to serach for a given player and retreive latest game status

  def self.player_search_input
    p "Enter the first and last name of your favorite player and hit enter to search."
    user_input = gets.chomp
    user_input.split(" ")
    p user_input ## just for testing
    ###PUT IN ERROR HANDLING FOR USER INPUT and validation
    ##QUERY API FOR PLAYERS LIST TO ENSURE VALID
  end

  #formats player_search_input into hash for API search
  def self.format_player_api_search(user_input)
    api_player_search = {}
    user_input.each do
      api_player_search[:first_name] = user_input[0]
      api_player_search[:last_name] = user_input[1]
    end
    p api_player_search ## for testing
  end

  ##combines methods to take user input to search player and return correct format for API search
  def self.full_user_input_and_search
    input = self.player_search_input
    format_player_api_search(input)
  end



end
