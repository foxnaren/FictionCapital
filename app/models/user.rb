class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
         
 	has_many :unreads
  has_many :chapters, through: :unreads
  
 	has_many :follows
  has_many :lightnovels, through: :follows
  
end
