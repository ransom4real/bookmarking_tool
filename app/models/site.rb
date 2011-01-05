class Site < ActiveRecord::Base
	has_many :bookmarks, :foreign_key => "site_id"
	
	validates_uniqueness_of :domain

end
