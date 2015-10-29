# this need to be a controller

desc "Add the next chapter"
task :add_next_chapter => :environment do
    
    require 'rubygems'
    require 'nokogiri'
	require 'open-uri'
	
	# ***********************change var to be inputed dynamically*********************
    current_chapter_number = 1
    @lightnovel = Lightnovel.find(1)
    
    get_next_chapter (current_chapter_number)
    
    def get_next_chapter(current_chapter_number)
    
	    next_chapter_number = current_chapter_number + 1
	
		if @lightnovel.chapters.find_by(chapter_number: next_chapter_number) == nil

            # combine the below 2 sentences if possiable
            home_url = @lightnovel.home_url
            puts home_url
            home_url_parsed = URI.parse(@lightnovel.home_url).host
            puts home_url_parsed
# 			home_url = URI.parse(@lightnovel.home_url)
# 			home_url_parsed = "{home_url.host}" 
			
			doc = Nokogiri::HTML(open(@lightnovel.home_url))
			
			puts doc.at_css(Selector.find_by(url_base: URI.parse(@lightnovel.home_url).host).selector).text
			
			link = doc.at_css(Selector.find_by(url_base: URI.parse(@lightnovel.home_url).host).selector)[:href]
			
			if link != nil
			    get_next_chapter(next_chapter_number)
			else
			
		end





end

