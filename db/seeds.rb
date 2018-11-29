# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
User.create(email: 'test@test.com', password: '12345678', username: 'test', birthday: '12/05/1992')
load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))
