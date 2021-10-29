class WordGuesserGame

  attr_accessor :word, :guesses, :wrong_guesses, :valid, :word_with_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.length
    @cnt = 0
  end

  def guess(letter)
    if letter.nil? || letter == ''
      @valid = false
      raise ArgumentError
    elsif (letter >= 'a' && letter <= 'z') || (letter >= 'A' && letter <= 'Z')
      letter = letter.downcase
      if @word.include? letter
        if @guesses.include? letter
          @valid = false
        else
          @guesses += letter
          @word.each_char.with_index do |c, i|
            # puts @word_with_guesses[i]
            @word_with_guesses[i] = letter unless c != letter
          end
          @valid = true
          @cnt += 1
        end
      else
        if @wrong_guesses.include? letter
          @valid = false
        else
          @wrong_guesses += letter
          @valid = true
          @cnt += 1

        end
      end
    else
      @valid = false
      raise ArgumentError
    end
  end

  def check_win_or_lose
    if @cnt <= 7 && @word_with_guesses == @word
      :win
    elsif @cnt == 7 && @word_with_guesses != @word
      :lose
    else
      :play
    end
  end


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
