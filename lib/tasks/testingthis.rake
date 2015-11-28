
desc "Used for testing"
task :t => :environment do

require 'rubygems'
require 'nokogiri'
require 'open-uri'

	time_in_hours  = 1

	oldest_time = (Time.now.to_s)/3600 - time_in_hours.hours.ago




end


 