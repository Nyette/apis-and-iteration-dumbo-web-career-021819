#!/usr/bin/env ruby

require_relative "../lib/api_communicator.rb"
require_relative "../lib/command_line_interface.rb"

welcome
character_name = get_character_name_from_user
show_character_film_titles(character_name)
