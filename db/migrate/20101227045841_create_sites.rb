class CreateSites < ActiveRecord::Migration
  def self.up
  create_table "sites", :force => true do |t|
    t.string    "name",          :default => "", :null => false
    t.string    "domain",        :default => "", :null => false
    t.timestamp "created_at",  :null => false
	
	t.timestamps
  end
  
  Site.new(:name=>"Ruby on Rails", :domain=>"oldwiki.rubyonrails.org").save
  end

  def self.down
    drop_table :sites
  end
end
