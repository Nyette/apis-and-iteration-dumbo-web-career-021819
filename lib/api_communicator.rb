require 'rest-client'
require 'json'
require 'pry'


def get_film_hashes(character_name)
  # should return an array of hashes, where each hash represents a film
  film_hashes = []
  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)
  response_hash["results"].each do |character_hash|
    if character_hash["name"] == character_name
      character_hash["films"].each do |film_url|
        film_string = RestClient.get(film_url)
        film_hash = JSON.parse(film_string)
        film_hashes << film_hash
      end
    end
  end
  film_hashes
end


def get_film_titles(film_hashes)
  film_titles = []
  film_hashes.each do |film_hash|
    film_hash.each do |key, value|
      if key == "title"
        film_titles << value
      end
    end
  end
  film_titles
end


def show_film_titles(character_name, film_titles)
  # puts out the movies in a nice list
  if film_titles.empty?
    puts "Not valid input!"
  else
    puts "#{character_name} appears in:"
    film_titles.each_with_index do |film_title, index|
      puts "#{index + 1}. #{film_title}"
    end
  end
end


def show_character_film_titles(character_name)
  film_hashes = get_film_hashes(character_name)
  film_titles = get_film_titles(film_hashes)
  show_film_titles(character_name, film_titles)
end
