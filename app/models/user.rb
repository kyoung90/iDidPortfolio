class User < ActiveRecord::Base
    has_many :projects
    has_many :likes
    has_secure_password
end
