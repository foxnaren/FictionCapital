require 'rubygems'
require 'nokogiri'
require 'open-uri'

class CheckLatestChapter
    include Sidekiq::Worker
    ## Input current_chapter_number: From @chapters.first.chapter_number, lightnovel_id: from the controller
    def perform(current_chapter_number, lightnovel_id)
        ## Populate lightnovel and calculate the next chapter number
        lightnovel = Lightnovel.find(lightnovel_id)
	    next_chapter_number = current_chapter_number + 1
	    #puts "#{lightnovel.id}"
	    ## check of the chapter number is present for the lightnovel
	    if lightnovel.chapters.find_by(chapter_number: next_chapter_number) == nil
	        ## get the url and parse it to get the base url
            chapter_url = lightnovel.chapters.find_by(chapter_number: current_chapter_number).chapter_url
            if @selector.blank?
                chapter_url_parsed = URI.parse(chapter_url).host
                ## check if the www. part of the url is present
                unless chapter_url_parsed.include?("www.")
                    chapter_url_parsed.insert(0, "www.")
                end
                @selector ||= Selector.find_by(url_base: chapter_url_parsed)
            end
            ## open the website
           	doc = Nokogiri::HTML(open(chapter_url))
           	next_chapter_text = doc.at_css(@selector.selector)
            ## check if the next chapter is blank or not ## check if the next chapter is a link ## check if the next chapter link is the same as the present chapter
    	    unless ((next_chapter_text).blank?) || (next_chapter_text[:href]).blank? || (chapter_url == (next_chapter_text[:href]))
                ## Populate the next chapter number and the next chapter url fields
                chapter_number = next_chapter_number
                chapter_url = next_chapter_text[:href]
                ## Open the next chapter page
                doc = Nokogiri::HTML(open(chapter_url))
                ## Populate the next chapter name from the newly opened page
                chapter_name = doc.at_css(@selector.name).text
                ## Create a new entry into the database
                Chapter.create lightnovel: lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: chapter_url
                # puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                ## Recursively call the function until the next chapter URL is blank
                perform(next_chapter_number, lightnovel)
            end
	    end
    end
end