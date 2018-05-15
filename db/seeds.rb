# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
    %w(admin moderator newuser).each do |role|
      Role.find_by(name: role.to_sym) || Role.new(name: role.to_sym).save
    end

    user = User.find_by(email: "anyemail@address.com") || User.new(email: "anyemail@address.com")
    user.password = "test1234"
    user.save

    user.add_role "admin"