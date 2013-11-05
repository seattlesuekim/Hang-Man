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
    if blank.include?('_') == false
      return 'user wins'
    end
    state
  end

  # Where secret and guess are both strings
  # This method also changes the "blank array"
  def play(secret, guess, blank)
    i = 0
    while i <= secret.length
      if secret[i] == guess
        blank[i] = guess
        i += 1
      else
        add_body_parts(i)
        break
      end
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

def make_blanks_array(secret_word)
  blanks_array = []
  i = 0
  while i <= (secret_word.length) / 2
    blanks_array << '_'
    i += 1
  end
  blanks_array.join(' ')
end

def game_engine
  game = Board.new
  secret_word = game.pick_random_word.scan(/\w/).join(' ')
  puts "The secret word is #{secret_word}"
  blanks_array = make_blanks_array(secret_word)

  # Game Play
  while game.determine_state(blanks_array) == 'in progress'
    puts 'Guess a letter: '
    puts blanks_array
    guess = gets.chomp
    blanks_array = game.play(secret_word, guess, blanks_array)
  end
  if game.determine_state(blanks_array) == 'computer wins'
    puts "Your inability to guess the word #{secret_word.to_s} has just killed this stick dude."
  elsif game.determine_state(blanks_array) == 'user wins'
    puts 'Congratulations! You have guessed the word!'
  end
end

game_engine