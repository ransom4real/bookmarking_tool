require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase

	test "should return domain regardless of url input format" do
		assert_equal "http://google.com", Bookmark.getdomain("http://www.google.com")
		assert_equal "http://google.com", Bookmark.getdomain("http://google.com")
		assert_equal "http://google.com", Bookmark.getdomain("google.com/blah")
		assert_equal "http://google.com", Bookmark.getdomain("www.google.com")
	end
	
	test "should return hash with empty string values if url not provided" do
	
		@hash = Bookmark.extract_data_from_url()
		assert_not_nil @hash
		assert_instance_of Hash, @hash
		assert_equal "", @hash["metadata"]
		assert_equal "", @hash["title"]
		assert_equal "", @hash["domain_title"]
	end
	
	#If an internet connection is available it should be able to retrieve the url's meta data but an empty domain title else test would fail
	test "should return hash with title and metadata but empty string value for domain title if url is provided and domain is not" do
		@hash = Bookmark.extract_data_from_url("http://oldwiki.rubyonrails.org/rails/pages/FullTextSearch")
		assert_not_nil @hash
		assert_instance_of Hash, @hash
		assert_equal "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />".downcase, @hash["metadata"].downcase
		assert_equal "FullTextSearch in Ruby on Rails", @hash["title"]
		assert_equal "", @hash["domain_title"]
	end
	
	#If an internet connection is available it should be able to retrieve the url's meta data and a domain title else test would fail
	test "should return hash with title and metadata and domaintitle if url and domain is provided" do
		@hash = Bookmark.extract_data_from_url("http://oldwiki.rubyonrails.org/rails/pages/FullTextSearch", Bookmark.getdomain("http://oldwiki.rubyonrails.org/rails/pages/FullTextSearch"))
		assert_not_nil @hash
		assert_instance_of Hash, @hash
		assert_equal "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />".downcase, @hash["metadata"].downcase
		assert_equal "FullTextSearch in Ruby on Rails".downcase, @hash["title"].downcase
		assert_equal "Ruby on Rails".downcase, @hash["domain_title"].downcase
	end
	
	test "search on all columns in the model" do
		bookmarks = Bookmark.search "ruby"
		assert_equal(1, bookmarks.size)
	end
	
	test "search on specific columns in the model" do
		bookmarks = Bookmark.search "ruby", :only => ["url", "tags"]
		assert_equal(1, bookmarks.size)
		bookmarks = Bookmark.search "ruby", :except => ["tags"]
		assert_equal(1, bookmarks.size)
	end
	
	test "search on all colums with an additional condition" do
		bookmarks = Bookmark.search "ruby", :conditions => "site_id = 1"
		assert_equal(1, bookmarks.size)
	end
	
	test "search on all colums with an additional condition should fail" do
		bookmarks = Bookmark.search "ruby", :conditions => "site_id = 2"
		assert_equal [], bookmarks
	end
	

end
