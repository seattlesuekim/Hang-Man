class Board
  attr_accessor :gallow

  def initialize
    @gallow = "    +==========|\n    #{@head}           |\n  #{@r_arm}#{@torso1}#{@l_arm}             |\n    #{@torso2}           |\n   #{@r_leg1}#{@l_leg1}            |\n  #{@r_leg2}  #{@l_leg2}           |\n               |\n        _______________"
    @head   = ' '
    @torso1 = ' '
    @torso2 = ' '
    @r_arm  = '  '
    @l_arm  = '  '
    @r_leg1 = '  '
    @r_leg2 = ' '
    @l_leg1 = ' '
    @l_leg2 = '  '
    puts @gallow
  end

  # The file contains one fruit per line
  def pick_random_word
    file = open('fruits.txt')
    file.readlines.sample
  end

  def determine_state(blank)
    state = 'in progress'
    # Left leg is the last body part
    if @l_leg2 == ' \\'
      return 'computer wins'
    end
    # User has filled out the blanks
    if not blank.include?('_')
      return 'user wins'
    end
    return state
  end

  # Where secret and guess are both arrays
  # This method also changes the "blank array"
  def play(secret, guess, blank)
    i = 0
    while i <= 5
      if guess[i] == secret[i]
        blank[i] = secret[i]
      else
        add_body_parts(i)
      end
      i+= 1
    end
    blank
  end


  def add_body_parts(i)
    if i == 0
      @head   = 'O'
    elsif i == 1
      @torso1 = '|'
      @torso2 = '|'
    elsif i == 2
      @r_arm  = '--'
    elsif i == 3
      @l_arm  = '--'
    elsif i == 4
      @r_leg1 = ' /'
      @r_leg2 = '/'
    elsif i == 5
      @l_leg1 = '\\'
      @l_leg2 = ' \\'
      # Game over
    end
  end
end

def game_engine
  game = Board.new
  puts " the secret word is #{game.pick_random_word}"
  secret_word_array = game.pick_random_word.scan(/\w/)
  blanks_array = []
  i = 0
  while i <= secret_word_array.count
    blanks_array << '_'
    i += 1
  end

  # Game Play
  while game.determine_state(blanks_array) == 'in progress'
    puts 'Guess the word: '
    puts blanks_array
    guess = gets.chomp.scan(/\w/)
    blanks_array = game.play(secret_word_array, guess, blanks_array)
  end
  if game.determine_state(blanks_array) == 'computer wins'
    puts "Your inability to guess the word #{secret_word_array.to_s} has just killed this stick dude."
  elsif game.determine_state(blanks_array) == 'user wins'
    puts 'Congratulations! You have guessed the word!'
  end
end

game_engine