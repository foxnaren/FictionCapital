# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



#Destination.create(name: "Ipanema", description: "The beach of Ipanema is known for its elegant development and its social life.", image: "http://s3.amazonaws.com/codecademy-content/courses/learn-rails/img/beach02.jpg", tag_id: t1.id)
#Destination.create(name: "7 Mile Beach", description: "The western coastline contains the island's finest beaches.", image: "http://s3.amazonaws.com/codecademy-content/courses/learn-rails/img/beach03.jpg", tag_id: t1.id)
#Destination.create(name: "El Castillo", description: "An elite destination famous for its white sand beaches", image: "http://s3.amazonaws.com/codecademy-content/courses/learn-rails/img/beach04.jpg", tag_id: t1.id)

lightnovel = Lightnovel.create(name: "LN", description: "LN desc", total_number_of_chapters: 40, raws_url: "www.fictioncapital.com", is_translated: true, translated_chapters: 20, translated_url: "www.royalroad.com")

Chapter.create(lightnovel_id: lightnovel.id, chapter_name: "test", chapter_number: 1, raws_url: "www.google.com", translated_url: "www.yahoo.com")


