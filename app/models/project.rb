class Project < ActiveRecord::Base
    has_many :likes
    belongs_to :user

    def slug
        self.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end 

    def self.find_by_slug(slug)
        self.all.find{|object| object.slug == slug}
    end 

    def self.find_by_slug_and_user_id(slug, user_id)
        self.all.find{|object| object.slug == slug && object.user_id = user_id}
    end
end
