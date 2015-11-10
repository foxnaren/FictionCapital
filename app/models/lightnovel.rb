class Lightnovel < ActiveRecord::Base
	# attr_accessible :name, :chapters_attributes
	
	validates :name, presence: true
	validates :description, presence: true
	validates :home_url, presence: true
	#validates :is_translated, presence: true
	validates :raws_url, presence: true, if: :translated?
	
	has_many :chapters, :dependent => :destroy
	accepts_nested_attributes_for :chapters

	def slug
		name.parameterize
	end
	
	def to_param
		if name
			"#{id}-#{slug}"
		end
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
	
	def chapter_attribute=(chapter_attribute)
		chapters.build(chapter_attribute)
	end
end
