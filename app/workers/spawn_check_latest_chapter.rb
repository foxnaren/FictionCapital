require 'rubygems'
require 'nokogiri'
require 'open-uri'

class HourlyLatestChapterCheck
    include Sidekiq::Worker

    def perform


    	@lightnovel = Lightnovel.where.not()

    	@lightnovel = Lightnovel.find_by(status: "Ongoing_Daily")
    	@lightnovel.each do |lightnovel|
    		case lightnovel.last_modified
    		when "Ongoing_Daily"
    			if 1.hour.ago > lightnovel.last_modified
	    			CheckLatestChapter.perform_async(lightnovel.number_of_chapters, lightnovel.id)
	    		end
	    		if 1.week.ago > lightnovel.chapters.last.created_at
	    			lightnovel.update_attributes(:last_modified => "Ongoing_Weekly")
	    		end
    		when "Ongoing_Weekly"
	    		if 1.day.ago > lightnovel.last_modified
	    			CheckLatestChapter.perform_async(lightnovel.number_of_chapters, lightnovel.id)
	    		end
	    		if 6.month.ago > lightnovel.chapters.last.created_at
	    			lightnovel.update_attributes(:last_modified => "Ongoing_Monthly")
	    		end
	    	when "Ongoing_Monthly"
	    		if 1.day.ago > lightnovel.last_modified
	    			CheckLatestChapter.perform_async(lightnovel.number_of_chapters, lightnovel.id)
	    		end
	    		if 3.month.ago > lightnovel.chapters.last.created_at
	    			lightnovel.update_attributes(:last_modified => "Hiatus_OR_Complete_3_Months")
	    		end
	    	when "Hiatus_OR_Complete_3_Months"
	    		if 1.week.ago > lightnovel.last_modified
	    			CheckLatestChapter.perform_async(lightnovel.number_of_chapters, lightnovel.id)
	    		end

    	end
	end





end



