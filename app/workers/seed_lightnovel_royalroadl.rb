require 'rubygems'
require 'nokogiri'
require 'open-uri'

class SeedLightnovelRoyalroadl
    include Sidekiq::Worker

    def perform(fictionID)
	    ##initialise total_royalroadl_fiction
	    total_royalroadl_fiction = fictionID+50
	    # total_royalroadl_fiction = 20

	    ##Loop through while total_royalroadl_fiction - fictionID is greater than 0
	    
	    while (total_royalroadl_fiction-fictionID) > 0
	        ##Set base URL
		    url = "http://royalroadl.com/fiction/#{fictionID}"
	        ## Check if the URL exsists in the database
	        if Lightnovel.find_by(home_url: url).blank?
	            ## If it exsists then open it via Nokogiri
		    	doc = open_url(url)
		    	#set title and chapter number count
		    	fiction_title = doc.at_css(".fiction-title")
				all_chapters  = doc.css(".chapter a") 
				all_chapters_count = all_chapters.count
	            ## Check if the fiction-title and chapter exsists in the URL opened
				unless fiction_title.blank? && all_chapters.blank?	                # sleep(5)
	                title = fiction_title.text
			    	description = doc.at_css(".description").text
		            selector_url_base = "www.royalroadl.com"
		            selector_next_chapter = "Royalroadl"
		            #td:nth-child(3) a
		            selector_name = "Royalroadl"
		            #div.largetext
		            #create Lightnovel entry
				    @lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url, :number_of_chapters => all_chapters_count, :selector_next_chapter => selector_next_chapter, :selector_name => selector_name, lightnovel_type: "Lightnovel"
				   	
				   	current_chapter_number = 1
				   	#loop through the chapters
				   	all_chapters.each do |chapter|
		    		    chapter_url = chapter['href'] 
					    chapter_name = chapter["title"]
					    #create the chapter
			            @chapter = Chapter.create :lightnovel => @lightnovel, :lightnovel_name => @lightnovel.name, :chapter_name => chapter_name, :chapter_number => current_chapter_number, :chapter_url => chapter_url
				    	current_chapter_number	=	current_chapter_number + 1
				    end
	                if (total_royalroadl_fiction-fictionID)<=50
	    	            total_royalroadl_fiction = total_royalroadl_fiction + 50
	                end
	            end
	            # puts "+++++#{fictionID}+++++++#{total_royalroadl_fiction}++++++"
	        else
	    	    # puts "****#{fictionID}******#{total_royalroadl_fiction}*****"
	            if (total_royalroadl_fiction-fictionID)<=50
	    	        total_royalroadl_fiction = total_royalroadl_fiction + 50
	            end
	        end    
	        fictionID = fictionID+1
	    end
    end

    def open_url(url)
        doc = ''
        open(url) do |fi|
            doc = Nokogiri::HTML(fi)
        end
        doc
    end
end