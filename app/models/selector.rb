class Selector < ActiveRecord::Base
    validates :url_base, presence: true, uniqueness: true
end
