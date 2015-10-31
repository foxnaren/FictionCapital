#     require 'rubygems'
#     require 'nokogiri'
# 	require 'open-uri'

class CheckLatestChapter
    include Sidekiq::Worker
    
    def perform(current_chapter_number, lightnovel_id)
        lightnovel = Lightnovel.find(lightnovel_id)
	    next_chapter_number = current_chapter_number + 1
	    puts "#{lightnovel.id}"
	    if lightnovel.chapters.find_by(chapter_number: next_chapter_number) == nil
            chapter_url = lightnovel.chapters.find_by(chapter_number: current_chapter_number).chapter_url
            chapter_url_parsed = URI.parse(chapter_url).host
            unless chapter_url_parsed.include?("www.")
                chapter_url_parsed.insert(0, "www.")
            end
           	doc = Nokogiri::HTML(open(chapter_url))
            selector ||= Selector.find_by(url_base: chapter_url_parsed)
    	    selector_next = selector.selector
            selector_name = selector.name
    	    unless (doc.at_css(selector_next)).blank?
                unless (doc.at_css(selector_next)[:href]).blank?
                    chapter_number = next_chapter_number
                    chapter_url = doc.at_css(selector_next)[:href]
                    doc = Nokogiri::HTML(open(chapter_url))
                    chapter_name = doc.at_css(selector_name).text
                    Chapter.create lightnovel: lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: chapter_url
                    # puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                    # get_next_chapter(next_chapter_number, lightnovel)
                end
            end
	    end
    end
end