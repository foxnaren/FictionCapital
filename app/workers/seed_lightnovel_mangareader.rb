require 'rubygems'
require 'nokogiri'
require 'open-uri'

class SeedLightnovelMangareader
    include Sidekiq::Worker

	def perform
    	base_url = "http://www.mangareader.net"
    	url = "http://www.mangareader.net/alphabetical"
        doc = Nokogiri::HTML(open(url))
    	all_manga = doc.css(".series_alpha li a")
        all_manga.each do |manga|
        	name = manga.text
            home_url = base_url + manga["href"]
            if Lightnovel.find_by(home_url: home_url).blank?
            	# puts ">>>>>>>manga<<<<<<<"
            	chapter_doc = Nokogiri::HTML(open(home_url))
        		description = chapter_doc.at_css("p").text
        		if description.blank?
            		description = "None"
        		end
            	number_of_chapters = chapter_doc.css("#listing a").count
                @lightnovel = Lightnovel.create name: name, description: description, home_url: home_url, number_of_chapters: number_of_chapters, selector_next_chapter: "manga", selector_name: "manga", lightnovel_type: "Manga"
        		chapter_number = 1
        		chapter_doc.css("#listing a").each do |chapter|
            		chapter_name = chapter.text
    	        	chapter_url = base_url + chapter['href'] 
        	    	# puts ">>>>>#{chapter_url}"
        	    	if @lightnovel.chapters.find_by(chapter_number: chapter_number).blank?
	            		@chapter = Chapter.create :lightnovel => @lightnovel, lightnovel_name: @lightnovel.name, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url
	            	end
            		# puts "#{chapter_number}"
            		chapter_number = chapter_number + 1
            	end
            end
        end
	end
end