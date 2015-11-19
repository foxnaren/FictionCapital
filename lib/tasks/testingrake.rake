    # this need to be a controller

desc "Add the next chapter"
task :testingthis => :environment do


    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    
    current_chapter_number = 6
    id =  1120

        if @lightnovel.blank?
            @lightnovel = Lightnovel.find(id)
        end
                        
        @doc = Nokogiri::HTML(open(@lightnovel.home_url))
        
        # current_chapter_number = @lightnovel.number_of_chapters
        puts ">>>>>#{@doc.css("#listing a").count}>>>>><<<<<<#{current_chapter_number}<<<<<"
        if @doc.css("#listing a").count > current_chapter_number
            
            @doc.css("#listing a")[(current_chapter_number) .. (@doc.css("#listing a").count-1)].each do |chapter|
               
               current_chapter_number = current_chapter_number + 1 
                chapter_name = chapter.text
                puts ">>>>>#{chapter_name}"            
            
                chapter_url = "http://www.mangareader.net" + chapter['href'] 
                puts ">>>>>#{chapter_url}"
            
                @chapter = Chapter.create :lightnovel => @lightnovel, :chapter_name => chapter_name, :chapter_number => current_chapter_number, :chapter_url => chapter_url
            
                puts "#{current_chapter_number}"


            end
            
        end
        # update_lightnovel_chapternumber_lastmod(current_current_chapter_number)



# def update_lightnovel_chapternumber_lastmod(current_current_chapter_number)
        if @lightnovel.number_of_chapters < current_chapter_number
            update_current_chapter_number = current_chapter_number
        else
            update_current_chapter_number = @lightnovel.number_of_chapters
        end
        @lightnovel.update_attributes(:number_of_chapters => update_current_chapter_number, :last_modified => Time.now)
    end

# end
