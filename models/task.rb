class User < ActiveRecord::Base
    include BCrypt

    has_and_belongs_to_many :circles
    has_many :tasks, dependent: :destroy
    has_many :alerts

    validates :name, :presence => :true, length:{minimum: 1}
    validates :email, uniqueness: true,  presence: true
    validates :username, uniqueness: true, presence: true
    validates :password, presence: true

  def password
    @password ||= Password.new password_hash
  end

  def password= new_password
    @password = Password.create new_password
    self.password_hash = @password
  end
  
end
 
class Task < ActiveRecord::Base

    belongs_to :user
    belongs_to :circle
    
    validates :name, :presence => :true, :length => {:maximum => 50, :minimum => 3}
    # validates :due, :presence => :true
end

class Circle < ActiveRecord::Base
    has_many :tasks, dependent: :destroy
    has_and_belongs_to_many :users
    validates :name, presence: true

    #validate ownerhip
end

class Alert < ActiveRecord::Base
    belongs_to :user
    #validate message on create
end
