# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Photo.all.each {|p| p.destroy}
Place.all.each {|p| p.destroy}

Place.create_indexes

f = File.open("./db/places.json");
Place.load_all(f)
Place.collection.count

Dir.glob("./db/image*.jpg") do |f|
  p = Photo.new
  file = File.open(f)
  p.contents = file
  p p.save
end

Photo.all.each do |p|
  p.place = p.find_nearest_place_id(1*1609.34)
  p.save
end
