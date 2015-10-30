# this need to be a controller

desc "Add the next chapter"
task :add_next_chapter => :environment do
    
    require 'rubygems'
    require 'nokogiri'
	require 'open-uri'
	
	# ***********************change var to be inputed dynamically*********************
    
    for ch in 1..10
        current_chapter_number = 1
        @lightnovel = Lightnovel.find(ch)
        get_next_chapter(current_chapter_number, @lightnovel)
    end
    
end

def get_next_chapter(current_chapter_number, lightnovel)

    next_chapter_number = current_chapter_number + 1

	if lightnovel.chapters.find_by(chapter_number: next_chapter_number) == nil

        # combine the below 2 sentences if possiable
        chapter_url = lightnovel.chapters.find_by(chapter_number: current_chapter_number).chapter_url
        puts chapter_url
        chapter_url_parsed = URI.parse(chapter_url).host

        unless chapter_url_parsed.include?("www.")
            chapter_url_parsed.insert(0, "www.")
        end
       
        puts chapter_url_parsed
# 			home_url = URI.parse(lightnovel.home_url)
# 			home_url_parsed = "{home_url.host}" 

    	doc = Nokogiri::HTML(open(chapter_url))
    	
    	# puts "doc"
    	selector ||= Selector.find_by(url_base: chapter_url_parsed)
    	selector_next = selector.selector
        selector_name = selector.name
    	# puts selector
        # puts doc.at_css(selector)
        # puts ".............."
        # 
        # puts ">>>>>>>>at sel<<<<<<<<"
    	unless (doc.at_css(selector_next)).blank?
            # puts ">>>>>>>>in unless 1<<<<<<<<,"
            unless (doc.at_css(selector_next)[:href]).blank?
                
                chapter_number = next_chapter_number
                chapter_url = doc.at_css(selector_next)[:href]

                doc = Nokogiri::HTML(open(chapter_url))
                chapter_name = doc.at_css(selector_name).text

                Chapter.create lightnovel: lightnovel, chapter_name: chapter_name, chapter_number: chapter_number, chapter_url: chapter_url

                puts ">>>#{lightnovel.name}>>>>>#{chapter_number}>>>>>#{chapter_url}<<<<<<<<<<"
                get_next_chapter(next_chapter_number, lightnovel)
            end
        end
	end
end
