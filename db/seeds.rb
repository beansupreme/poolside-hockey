# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
require 'faker'

10.times do
  Player.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    position: Player::POSITIONS.sample,
    origin_country: Faker::WorldCup.team
  )
end