class ApplicationController < ActionController::Base

  protect_from_forgery
  @bookmarking = Bookmark.new
  
end
