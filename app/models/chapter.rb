class Chapter < ActiveRecord::Base
	
	belongs_to :lightnovel, touch: true
	
	has_many :unreads
    has_many :users, through: :unreads

end
