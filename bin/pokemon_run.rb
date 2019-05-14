#!/usr/bin/env ruby

require_relative "../lib/pokemon_api_comms.rb"
require_relative "../lib/pokemon_command_line_interface.rb"

pokemon_urls = get_pokemon_urls
pokemon_hashes = get_pokemon_hashes(pokemon_urls)
# moves
# types
simplified_pokemon_hashes = get_simplified_pokemon_hashes(pokemon_hashes)
