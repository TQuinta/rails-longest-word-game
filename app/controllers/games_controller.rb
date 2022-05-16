require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @array = (0...10).map { ('a'..'z').to_a[rand(26)].capitalize }
  end

  def score
    @array = params[:array].remove(' ').chars
    return @response = 'not a real word' unless word_exists?(params[:word])

    word_works(@array)
    @response = 'well done that word existed' if @response.nil?
    return @score = 0 if @response == 'damn you cheating'

    @score = (params[:word].length + 10)
  end

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    resp_serialized = URI.open(url).read
    resp = JSON.parse(resp_serialized)
    resp['found'] == true
  end

  def word_works(array)
    params[:word].upcase.chars.each do |letter|
      if array.include?(letter)
        index = @array.find_index(letter)
        array.delete_at(index)
      else
        @response = 'damn you cheating'
      end
    end
  end
end
