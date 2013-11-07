require 'colorize'
class Board

  def initialize
    @head   = ' '
    @torso1 = ' '
    @torso2 = ' '
    @r_arm  = '  '
    @l_arm  = '  '
    @r_leg1 = '  '
    @r_leg2 = ' '
    @l_leg1 = ' '
    @l_leg2 = '  '
  end

  def make_gallow
    gallow = "    +==========|\n    #{@head}          |\n  #{@r_arm}#{@torso1}#{@l_arm}        |\n    #{@torso2}          |\n   #{@r_leg1}#{@l_leg1}         |\n   #{@r_leg2} #{@l_leg2}        |\n               |\n        _______|_______"
    gallow
  end

  # The file contains one fruit per line
  def pick_random_word
    file = open('fruits.txt')
    file.readlines.sample.downcase
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

  def add_body_parts(i)
    if i == 0
      @head   = 'o'.colorize(:light_red)
    elsif i == 1
      @head   = 'o'.colorize(:red)
      @torso1 = '|'
      @torso2 = '|'
    elsif i == 2
      @head = 'O'.colorize(:light_magenta)
      @r_arm  = '--'
    elsif i == 3
      @head = 'O'.colorize(:cyan)
      @l_arm  = '--'
    elsif i == 4
      @head = '0'.colorize(:blue)
      @r_leg1 = ' /'
      @r_leg2 = '/'
    elsif i == 5
      @head = 'D'.black.on_red.blink
      @l_leg1 = '\\'
      @l_leg2 = ' \\'
    end
  end


end

# This method takes returns the number of blanks which is the ceiling of the secret word length / 2.
def make_blanks_array(secret_word)
  blanks_array = ['_'] * (secret_word.length.to_f / 2).ceil
  blanks_array.join' '
end

def game_engine
  game = Board.new
  secret_word = game.pick_random_word.scan(/\w/).join(' ')
  blanks_array = make_blanks_array(secret_word)
  state = game.determine_state(blanks_array)
  penalty = 0
  letter_list = []

  # Interactive Section
  while state == 'in progress'
    puts game.make_gallow
    puts blanks_array
    puts "You get #{6 - penalty} chance(s). Don't make me kill this sucka."
    puts 'Guess a letter: '
    guess = gets.chomp.split(//).join(' ')
    # Check for repeat guesses
    if not letter_list.include?(guess)
      letter_list << guess
    else
      puts "You already guessed #{guess}"
      next
    end
    if secret_word.include?(guess)
      index_list = get_indices(guess, secret_word)
      index_list.each do |i|
      blanks_array[i] = guess
      end
    else
      puts "There is no #{guess}."
      game.add_body_parts(penalty)
      penalty += 1
    end
    state = game.determine_state(blanks_array)
  end

  # Who won?
  if game.determine_state(blanks_array) == 'computer wins'
    puts game.make_gallow
    puts "OH MY GOD YOU KILLED KENNY! The secret word was #{secret_word.to_s.gsub(/\s+/, "")}."
  elsif game.determine_state(blanks_array) == 'user wins'
    puts blanks_array
    puts 'Congratulations! You have guessed the word!'
  end
end


# Returns an array containing the indices of all occurrences of a letter in a word
def get_indices(letter, word)
  index_list = []
  (0..word.length).each do |i|
    if word[i] == letter
      index_list << i
    end
  end
  index_list
end

game_engine

