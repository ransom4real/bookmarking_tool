require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :redirect
  end
  
  test "should return to index" do
    post :new
	assert_nil assigns(:bookmark)
    assert_response :redirect
	assert_redirected_to :controller => "bookmarks", :action => "index", :new => "1"
	assert_equal "Incorrect parameters supplied. Check and try again", flash[:error]
  end
  
  test "should save bookmark and return to index" do
    post(:new, {'bookmarking' => {'url' => "http://www.chrisumbel.com/article/html_parsing_with_ruby_and_nokogiri.aspx", 'tags' => "HTML Parsing, Parsing, Ruby, Rails, Nokogiri"}})
    assert_not_nil assigns(:bookmark)
	assert_response :redirect
	assert_redirected_to :controller => "bookmarks", :action => "index"
	assert_equal "Bookmark has been created successfully", flash[:notice]
  end

  test "should get list" do
    get(:list, {'site' => "1"})
    assert_response :success
  end
  
  test "should redirect to error page if no site id" do
    get :list
	assert_nil assigns(:sites)
	assert_equal "The page you requested does not exist or has moved", flash[:error]
    assert_response :redirect
  end
  
  test "search without query should still return bookmarks" do
    post :search
	assert_equal "", assigns(:query)
	assert_not_nil assigns(:bookmarks)
	assert_response :success
  end
  
  test "search should return bookmarks" do
    post(:search, {'bookmark' => {'query' => "ruby"}})
	assert_equal "ruby", assigns(:query)
	assert_not_nil assigns(:bookmarks)
	assert_response :success
  end
  

end
