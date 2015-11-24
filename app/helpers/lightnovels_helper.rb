module LightnovelsHelper

	def extlink(link)
  		if link.include?("http://") || link.include?("https://")
   			link
  		else
   			link.insert(0, "http://")
   			link
  		end
  	end
end
