class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table "bookmarks", :force => true do |t|
    t.string    "url",                        :default => "", :null => false
    t.string    "tags"
    t.string    "page_title",		:limit => 1000
    t.string    "meta_data",		:limit => 1000
    t.string    "tiny_url",                   :default => "", :null => false
    t.integer   "site_id",       :limit => 20, :default => 1,  :null => false
    t.timestamp "created_at",   :default => Date.today, :null => false
	
	t.timestamps
  end
  
    add_index "bookmarks", ["site_id"], :name => "FK_bookmarks"
  end

  def self.down
    drop_table :bookmarks
  end
end
