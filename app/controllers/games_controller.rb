require 'open-uri'
require 'json'

class GamesController < ApplicationController
  WAGON_URL = "https://wagon-dictionary.herokuapp.com/"

  def new
    @letters = generate_grid(9)
  end

  def score
    @letters = params[:hiddenLetters]
    @guess = params[:guess]
    @found = check_word(@guess)
    @lettersOriginal = params[:hiddenLetters]
    @checkGrid = in_grid?(@guess, @letters)
    @lettersOriginal = params[:hiddenLetters]
  end

  def generate_grid(grid_size)
    # p "grid size #{grid_size}"
    random_grid = []
    while random_grid.size < grid_size
      random_grid << ('A'..'Z').to_a[rand(26)]
    end
    random_grid
  end

  def check_word(attempt)
    url = WAGON_URL + attempt # add word to URL
    check_word = open(url).read
    check_word = JSON.parse(check_word)
    return check_word["found"]
  end

  def in_grid?(attempt, grid)
    # grid is a bunch of leters
    # attempt is a word
    # word should have all letters that grid has
    # for each character in attempt, remove letter from grid
    grid = grid.dup
    attempt.chars.each do |letter|
      letter = letter.upcase
      return false unless grid.include?(letter)

      grid.slice!(grid.index(letter))
    end
    return true
  end
end
