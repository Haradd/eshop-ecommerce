# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


12.times do
  Product.create(
    name: FFaker::Lorem.words(rand(3..6)).join(" "),
    description: FFaker::Lorem.sentence,
    price: rand(9..109).round(2)
  )
end
