require 'rubygems'
require 'nokogiri'
require 'open-uri'

class HourlyLatestChapterCheck
    include Sidekiq::Worker

    1) Check status of Lightnovel
	2) if there are no updates for 2 months switch status for hiatus or stopped
		a) Switch to weekly checks
	3) if no updates for 6 months switch to 6m Hiatus/Stopped or Complete status, do monthly status checks

Manual check option for users.
	
	



end
