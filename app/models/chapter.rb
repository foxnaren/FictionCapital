class Chapter < ActiveRecord::Base
	
	belongs_to :lightnovel, touch: true

end
