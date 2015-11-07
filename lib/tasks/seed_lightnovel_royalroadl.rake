desc "Used to seed lightnovel"
task :seed_lightnovel_royalroadl => :environment do

    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'

    ##initialise fictionID and total_royalroadl_fiction
    fictionID = 0
    total_royalroadl_fiction = fictionID+100

    ##Loop through while total_royalroadl_fiction - fictionID is greater than 0
    
    while (total_royalroadl_fiction-fictionID) > 0
	    # puts ">>>>>fictionID>>>>#{fictionID}<<<<<<<<<"
        ##Set base URL
	    url = "http://royalroadl.com/fiction/#{fictionID}"
	    # puts ">>>>>url>>>>#{url}<<<<<<<<<"
        ## Check if the URL exsists in the database
        if Lightnovel.find_by(home_url: url).nil?
            ## If it exsists then open it via Nokogiri
	    	doc = Nokogiri::HTML(open(url))
            ## Check if the fiction-title and chapter exsists in the URL opened
            if (doc.at_css(".fiction-title") != nil) && (doc.at_css(".chapter:nth-child(1) a") != nil)
                ## Populate title and description	    	    
	    		title = doc.at_css(".fiction-title").text
	            description = doc.at_css(".description").text
	            # puts ">>>>>title>>description>>#{title}<<<<<#{description}<<<<"
                ## Create the new Light novel in the database	            
    		    @lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url
                ## Populate the first chapter URL, name and number                    
    		    chapter_url = doc.at_css(".chapter:nth-child(1) a")['href'] 
    		    chapter_name = doc.at_css(".chapter:nth-child(1) span:nth-child(1)").text
                chapter_number = 1
                # puts ">>>>>#{chapter_name}>>#{chapter_url}<<<<>>#{chapter_number}<<<<<lightnovel.id<<<<"   
                ## Create the new chapter in the database	            
                @chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url
                ##>>>>>>>>>>Add a scheduled task to recursively add new chapters to the database<<<<<<<<<<<<<<
                #CheckLatestChapter.perform_in(1.hour, chapter_number, @lightnovel.id)
                ## If the chapter exsists check to update the condition
                if (total_royalroadl_fiction-fictionID)<=50
    	            total_royalroadl_fiction = total_royalroadl_fiction + 50
                end
            end
            puts "+++++#{fictionID}+++++++#{total_royalroadl_fiction}++++++"
        else
    	    puts "****#{fictionID}******#{total_royalroadl_fiction}*****"
            if (total_royalroadl_fiction-fictionID)<=50
    	        total_royalroadl_fiction = total_royalroadl_fiction + 50
            end
        end    
        fictionID = fictionID+1
    end
end
