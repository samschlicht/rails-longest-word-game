require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = []

    10.times do
      @letters << alphabet[rand(0..25)]
    end

    @letters
  end

  def score
    word = params[:word].upcase
    if word.length == 0
      @message = "Come on, you didn't even try!"
    end
    grid = params[:letters]
    in_dictionary = word_checker(word)["found"]
    an_anagram = anagram_checker(grid, word)
    if in_dictionary && an_anagram
      @message = "Well done! Your score is #{word.length * 10}"
    elsif in_dictionary && an_anagram == false
      @message = "Sorry, that's not in the grid!"
    elsif in_dictionary == false
      @message = "Sorry, that's not an English word!"
    end
    @message
  end

  private

  def word_checker(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    JSON.parse(user_serialized)
  end

  def anagram_checker(grid, word)
    test_word = word.dup
    grid.each_char { |char| test_word.sub!(char, "") }
    test_word.size.zero?
  end
end
