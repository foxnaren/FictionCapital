require 'rubygems'
require 'nokogiri'
require 'open-uri'
## need to test the changes
#test comment
class CheckLatestChapter
    include Sidekiq::Worker

    def perform(current_chapter_number, id)

        @lightnovel = Lightnovel.find(id)
        if @lightnovel.lightnovel_type == "Lightnovel"
            perform_lightnovel(current_chapter_number, id)
        elsif @lightnovel.lightnovel_type == "Manga"
            perform_manga(current_chapter_number, id)            
        end
    end

    def perform_manga(current_chapter_number, id)
        ## Populate lightnovel and calculate the next chapter number
        if @lightnovel.blank?
            @lightnovel = Lightnovel.find(id)
        end        
        next_chapter_number = current_chapter_number + 1
        next_chapter_object = @lightnovel.chapters.find_by(chapter_number: next_chapter_number)
        if next_chapter_object == nil
            next_chapter_url = @lightnovel.home_url + "/" + next_chapter_number
            next_chapter_name = @lightnovel.name + " " + next_chapter_number
            catch(:stop) do
                begin
                    @doc = Nokogiri::HTML(open(next_chapter_url))
                    rescue OpenURI::HTTPError => e
                        if e.message == '404 Not Found'
                            update_lightnovel_chapternumber_lastmod(current_chapter_number)                            
                            # puts "+++++++++++++++++++++++stop thrown+++++++#{current_chapter_number}++++++++++++"
                            throw :stop
                        else
                            raise e
                        end
                end
                Chapter.create lightnovel: @lightnovel, chapter_name: next_chapter_name, chapter_number: next_chapter_number, chapter_url: next_chapter_url
                perform_manga(next_chapter_number, id)
            end
        else
            logger.info "ERROR: #{current_chapter_number}, #{id}, Next chapter was present in db"
            update_lightnovel_chapternumber_lastmod(current_chapter_number)
        end
    end
    ## Input current_chapter_number: From @chapters.first.chapter_number, lightnovel_id: from the controller
    def perform_lightnovel(current_chapter_number, id)
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
                catch(:stop) do
                    ## Populate the next chapter number and the next chapter url fields
                    chapter_number = next_chapter_number
                    ## Open the next chapter page
                    begin
                        @doc = Nokogiri::HTML(open(next_chapter_link))
                        rescue OpenURI::HTTPError => e
                            if e.message == '404 Not Found'
                                update_lightnovel_chapternumber_lastmod(current_chapter_number)                            
                                # puts "+++++++++++++++++++++++stop thrown+++++++#{current_chapter_number}++++++++++++"
                                throw :stop
                            else
                                raise e
                            end
                    end 
                    # puts "#{next_chapter_link}"
                    ## Populate the next chapter name from the newly opened page
                    chapter_name = @doc.at_css(@lightnovel.selector_name).text
                    ## Create a new entry into the database
                    Chapter.create lightnovel: @lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: next_chapter_link
                    # puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                    @current_chapter_url = next_chapter_link
                    ## Recursively call the function until the next chapter URL is blank
                    perform_lightnovel(next_chapter_number, @lightnovel.id)
                end
            end
	    else
            logger.info "ERROR: #{current_chapter_number}, #{id}, Next chapter was present in db"
            update_lightnovel_chapternumber_lastmod(current_chapter_number)
	    end
    end
    
    def update_lightnovel_chapternumber_lastmod(current_chapter_number)
        if @lightnovel.number_of_chapters < current_chapter_number
            update_chapter_number = current_chapter_number
        else
            update_chapter_number = @lightnovel.number_of_chapters
        end
        @lightnovel.update_attributes(:number_of_chapters => update_chapter_number, :last_modified => Time.now)
    end
end