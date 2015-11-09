class Lightnovel < ActiveRecord::Base
	validates :name, presence: true
	validates :description, presence: true
	validates :home_url, presence: true
	#validates :is_translated, presence: true
	validates :raws_url, presence: true, if: :translated?
	
	has_many :chapters, :dependent => :destroy

	def slug
       	name.parameterize
  	end
  
    def to_param
        "#{id}-#{slug}"
    end

    def translated?
    	is_translated == true
    end

	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    all
	  end
	end
    
end
