class User < ActiveRecord::Base
  has_and_belongs_to_many :circles
  has_many :tasks
  
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :name, :username, :password, :email, presence: true
  has_many :tasks
end
 
class Task < ActiveRecord::Base
  belongs_to :user
end

class Circle < ActiveRecord::Base
  has_and_belongs_to_many :users
end