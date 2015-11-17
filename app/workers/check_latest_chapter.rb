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
            end

            ## open the website
            if @doc.blank?
                @doc = Nokogiri::HTML(open(@current_chapter_url)) 
            end
            logger.debug ">>>>>>>>>>>>>>><<<<<<<<<<<<<<<"

           	next_chapter_text = @doc.at_css(@lightnovel.selector_next_chapter)

            unless next_chapter_text.blank?
                next_chapter_link = next_chapter_text[:href]
            end
            ## check if the next chapter is blank or not ## check if the next chapter is a link ## check if the next chapter link is the same as the present chapter
            if ((next_chapter_text).blank?) || (next_chapter_link).blank? || (@current_chapter_url == (next_chapter_link))
                update_lightnovel_chapternumber_lastmod(current_chapter_number)
    	    else 
                ## Populate the next chapter number and the next chapter url fields
                chapter_number = next_chapter_number
                ## Open the next chapter page
                @doc = Nokogiri::HTML(open(next_chapter_link))
                # puts "#{next_chapter_link}"
                ## Populate the next chapter name from the newly opened page
                chapter_name = @doc.at_css(@lightnovel.selector_name).text
                ## Create a new entry into the database
                Chapter.create lightnovel: @lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: next_chapter_link
                # puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                @current_chapter_url = next_chapter_link
                ## Recursively call the function until the next chapter URL is blank
                perform(next_chapter_number, @lightnovel.id)
            end
	    else
            update_lightnovel_chapternumber_lastmod(current_chapter_number)
	    end
    end
    
    def update_lightnovel_chapternumber_lastmod(current_chapter_number)
        if @lightnovel.number_of_chapters < current_chapter_number
            update_chapter_number = current_chapter_number
        else
            update_chapter_number = @lightnovel.number_of_chapters
        end
        @lightnovel.update_attributes(:number_of_chapters => current_chapter_number, :last_modified => Time.now)
    end
end