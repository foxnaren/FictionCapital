desc "testing"
task :testingthis => :environment do
    
    require 'rubygems'
    require 'nokogiri'
	require 'open-uri'
	
	@lightnovel = Lightnovel.find(1)
		
		# home_url = @lightnovel.chapters.find_by(chapter_number: 1).chapter_url
		home_url = "http://www.royalroadl.com/forum/showthread.php?tid=7778"
        puts home_url
        home_url_parsed = URI.parse(@lightnovel.home_url).host
        puts home_url_parsed
# 			home_url = URI.parse(@lightnovel.home_url)
# 			home_url_parsed = "{home_url.host}" 

    	doc = Nokogiri::HTML(open(home_url))
    	
    	puts "doc"
    	
    	sel = Selector.find_by(url_base: home_url_parsed).selector
    	
    	puts sel
		
		puts doc.at_css(sel)[:href]
end
	