require 'rest-client'
require 'json'
require 'pry'


def get_pokemon_urls
  pokemon_urls = []
  response_string = RestClient.get('https://pokeapi.co/api/v2/pokemon')
  response_hash = JSON.parse(response_string)
  pokemon_hashes = response_hash["results"]
  pokemon_hashes.each do |pokemon_hash|
    pokemon_hash.each do |key, value|
      if key == "url"
        pokemon_url = value
        pokemon_urls << pokemon_url
      end
    end
  end
  # puts pokemon_urls[3]
  pokemon_urls
end


def get_pokemon_hashes(pokemon_urls)
  pokemon_hashes = []
  pokemon_urls.each do |pokemon_url|
    pokemon_string = RestClient.get(pokemon_url)
    pokemon_hash = JSON.parse(pokemon_string)
    pokemon_hashes << pokemon_hash
  end
  # puts pokemon_hashes[3]["name"]
  pokemon_hashes
end


def get_simplified_pokemon_hashes(pokemon_hashes)
  simplified_pokemon_hashes = []
  pokemon_hashes.each do |pokemon_hash|
    # create a simplified copy of each hash
    simplified_pokemon_hash = pokemon_hash.slice("id", "name", "sprites", "types", "moves")
    # change the value associated with "sprites", so that
    # it points to the value of the front/default sprite
    simplified_pokemon_hash["sprites"] = simplified_pokemon_hash["sprites"]["front_default"]
    # change "sprites" to "sprite"
    simplified_pokemon_hash["sprite"] = simplified_pokemon_hash["sprites"]
    # remove the copy
    simplified_pokemon_hash.delete_if do |key, value|
      key == "sprites"
    end
    # change the value of "moves", so that it points to an array of
    # strings, which are the names of the moves that the Pokémon can learn
    move_names = []
    simplified_pokemon_hash["moves"].each do |move|
      move.each do |key, value|
        if key == "move"
          value.each do |attr, string|
            if attr == "name"
              move_name = string
              move_names << move_name
              # binding.pry
            end
          end
        end
      end
    end
    sorted_move_names = move_names.first(10).sort
    # create a string out of the array of names
    simplified_pokemon_hash["moves"] = sorted_move_names * ', '
    # change the value of "types", so that it points to an array of
    # strings, which are the names of the types
    type_names = []
    simplified_pokemon_hash["types"].each do |type|
      type.each do |key, value|
        if key == "type"
          value
          value.each do |attr, string|
            if attr == "name"
              type_name = string
              type_names << type_name
              # binding.pry
            end
          end
        end
      end
    end
    sorted_type_names = type_names.sort
    # create a string out of the array of names
    simplified_pokemon_hash["types"] = sorted_type_names * ', '
    # add the simplified hash to the associated collection
    simplified_pokemon_hashes << simplified_pokemon_hash
  end
  # puts simplified_pokemon_hashes[3]
  simplified_pokemon_hashes
end


def get_all_moves(simplified_pokemon_hashes)
  names_of_moves = []
  simplified_pokemon_hashes.each do |pokemon_hash|
    pokemon_hash.each do |key, value|
      if key == 'moves'
        # value = 'bind, cut, ember'
        pokemon_moves_array = value.split(', ')
        # pokemon_moves_array = ['bind', 'cut', 'ember']
        pokemon_moves_array.each do |move_name|
          names_of_moves << move_name
          # binding.pry
        end
      end
    end
  end
  # puts names_of_moves.uniq.sort
  names_of_moves.uniq.sort
  # binding.pry
end

def get_all_move_hashes(names_of_moves)
  move_hashes = []
  names_of_moves.each do |move_name|
    move_string = RestClient.get("https://pokeapi.co/api/v2/move/#{move_name}/")
    move_hash = JSON.parse(move_string)
    simple_move_hash = move_hash.slice("id", "name", "power", "accuracy", "effect_entries")
    simple_move_hash["effect_entries"] = simple_move_hash["effect_entries"][0]["short_effect"]
    simple_move_hash["effect"] = simple_move_hash["effect_entries"]
    simple_move_hash.delete_if do |key, value|
      key == "effect_entries"
    end
    effect_substring = "Has a $effect_chance% chance to"
    if simple_move_hash["effect"].include? effect_substring
      simple_move_hash["effect"] = simple_move_hash["effect"].sub(effect_substring, "May")
    else
      simple_move_hash["effect"]
    end
    move_hashes << simple_move_hash
    # binding.pry
  end
  # puts move_hashes[0..1]
  move_hashes
end
