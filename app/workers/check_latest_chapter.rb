require 'rubygems'
require 'nokogiri'
require 'open-uri'
## need to test the changes
#test comment
class CheckLatestChapter
    include Sidekiq::Worker
    ## Input current_chapter_number: From @chapters.first.chapter_number, lightnovel_id: from the controller
    def perform(current_chapter_number, id)
        ## Populate lightnovel and calculate the next chapter number
        if @lightnovel.blank?
            @lightnovel = Lightnovel.find(id)
        end
	    next_chapter_number = current_chapter_number + 1
	    #puts "#{lightnovel.id}"
	    ## check of the chapter number is present for the lightnovel
        next_chapter_object = @lightnovel.chapters.find_by(chapter_number: next_chapter_number)
	    if next_chapter_object == nil
	        ## get the url and parse it to get the base url
            if @current_chapter_url.blank?
                @current_chapter_url = @lightnovel.chapters.find_by(chapter_number: current_chapter_number).chapter_url
                ## ********NEED TO BE CACHED*********
            end

            if @selector.blank?
                chapter_url_parsed = URI.parse(@current_chapter_url).host
                ## check if the www. part of the url is present
                unless chapter_url_parsed.include?("www.")
                    chapter_url_parsed.insert(0, "www.")
                end
                @selector = Selector.find_by(url_base: chapter_url_parsed)
            end
            ## open the website
            if @doc.blank?
           	    @doc = Nokogiri::HTML(open(@current_chapter_url)) 
            end
           	next_chapter_text = doc.at_css(@selector.selector)
            next_chapter_link = next_chapter_text[:href]
            ## check if the next chapter is blank or not ## check if the next chapter is a link ## check if the next chapter link is the same as the present chapter
            if ((next_chapter_text).blank?) || (next_chapter_link).blank? || (@current_chapter_url == (next_chapter_link))
                if @lightnovel.number_of_chapters < current_chapter_number
                    @lightnovel.update_attributes(:number_of_chapters => current_chapter_number)
                end
    	    else 
                ## Populate the next chapter number and the next chapter url fields
                chapter_number = next_chapter_number
                ## Open the next chapter page
                @doc = Nokogiri::HTML(open(next_chapter_link))
                ## Populate the next chapter name from the newly opened page
                chapter_name = doc.at_css(@selector.name).text
                ## Create a new entry into the database
                Chapter.create lightnovel: @lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: next_chapter_link
                # puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                @current_chapter_url = next_chapter_link
                ## Recursively call the function until the next chapter URL is blank
                perform(next_chapter_number, @lightnovel.id)
            end
	    end
    end
end