desc "Used to seed lightnovel"
task :seed_lightnovel_mangareader => :environment do

    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    
    base_url = "http://www.mangareader.net"
    url = "http://www.mangareader.net/alphabetical"
    
    doc = Nokogiri::HTML(open(url))
    all_manga = doc.css(".series_alpha li a")
    
    all_manga[31..70].each do |manga|
        
        name = manga.text
        # puts "#{name}<<<<<<<<<<"
        
        # puts "#{manga["href"]}<<<<<<<<<<"
        
        home_url = base_url + manga["href"]
        
        # puts "#{home_url}<<<<<<<<<<"
        
        chapter_doc = Nokogiri::HTML(open(home_url))
        description = chapter_doc.at_css("p").text
        
        if description.blank?
            description = "None"
        end
            
        
        # puts "#{description}"
        
        number_of_chapters = chapter_doc.css("#listing a").count
        
        # puts ">>>>>#{number_of_chapters}"
        
        # puts "#{chapter_url}"
        # type = "manga"

        @lightnovel = Lightnovel.create name: name, description: description, home_url: home_url, number_of_chapters: number_of_chapters, selector_next_chapter: "manga", selector_name: "manga", lightnovel_type: "manga"
        
        chapter_number = 1
        
        chapter_doc.css("#listing a").each do |chapter|
        
            chapter_name = chapter.text
            # puts ">>>>>#{chapter_name}"            
            
            chapter_url = base_url + chapter['href'] 
            puts ">>>>>#{chapter_url}"
            
            @chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => chapter_number, :chapter_url => chapter_url
            
            puts "#{chapter_number}"
            chapter_number = chapter_number + 1
        end
    end
end