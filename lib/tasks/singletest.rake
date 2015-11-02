desc "Used to test single instance"
task :singletest => :environment do

    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'

    fictionID = 54
    total_royalroadl_fiction = fictionID+100
    while (total_royalroadl_fiction-fictionID) > 0

	    # puts ">>>>>fictionID>>>>#{fictionID}<<<<<<<<<"

	    url = "http://royalroadl.com/fiction/#{fictionID}"
	    # puts ">>>>>url>>>>#{url}<<<<<<<<<"

	    if Lightnovel.find_by(home_url: url).nil?
	    	doc = Nokogiri::HTML(open(url))
	    	if doc.at_css(".fiction-title") != nil
	    		title = doc.at_css(".fiction-title").text
	            description = doc.at_css(".description").text
	            # puts ">>>>>title>>description>>#{title}<<<<<#{description}<<<<"
	    		@lightnovel = Lightnovel.create :name => title, :description => description, :home_url => url
	    		chapter_url = doc.at_css(".chapter:nth-child(1) a")['href'] 
	    		chapter_name = doc.at_css(".chapter:nth-child(1) span:nth-child(1)").text
	            chapter_number = 1
	            # puts ">>>>>#{chapter_name}>>#{chapter_url}<<<<>>#{chapter_number}<<<<<lightnovel.id<<<<"   
	            @chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url
	            CheckLatestChapter.perform_in(1.hour, chapter_number, @lightnovel.id) 
	        end
	        puts ">>>#{fictionID}<<<>>>#{total_royalroadl_fiction}<<<"
	    else
	    	puts "****#{fictionID}******#{total_royalroadl_fiction}*****"
	        if (total_royalroadl_fiction-fictionID)<=50
    	        total_royalroadl_fiction = total_royalroadl_fiction + 50
	    	end
	    end
	    fictionID = fictionID+1
	end
end