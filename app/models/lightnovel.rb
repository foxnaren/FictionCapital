class Lightnovel < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true
	validates :total_number_of_chapters, presence: true
	validates :raws_url, presence: true
	#validates :is_translated, presence: true
	validates :translated_chapters, presence: true, if: :translated?
	validates :translated_url, presence: true, if: :translated?
	
	has_many :chapters

	def slug
        name.downcase.gsub(" ", "-")
    end
    
    def to_param
        "#{id}-#{slug}"
    end

    def translated?
    	is_translated == true
    end
    
end
